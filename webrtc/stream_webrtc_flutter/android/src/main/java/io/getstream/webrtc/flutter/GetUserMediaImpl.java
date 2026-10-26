package io.getstream.webrtc.flutter;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Point;
import android.hardware.camera2.CameraManager;
import android.media.AudioDeviceInfo;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionConfig;
import android.media.projection.MediaProjectionManager;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import android.os.ResultReceiver;
import android.provider.MediaStore;
import android.util.Log;
import android.util.Pair;
import android.util.SparseArray;
import android.view.Display;
import android.view.Surface;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import io.getstream.webrtc.flutter.audio.AudioSwitchManager;
import io.getstream.webrtc.flutter.audio.AudioUtils;
import io.getstream.webrtc.flutter.audio.LocalAudioTrack;
import io.getstream.webrtc.flutter.audio.ScreenAudioCapturer;

import java.nio.ByteBuffer;
import io.getstream.webrtc.flutter.record.AudioChannel;
import io.getstream.webrtc.flutter.record.AudioSamplesInterceptor;
import io.getstream.webrtc.flutter.record.MediaRecorderImpl;
import io.getstream.webrtc.flutter.record.OutputAudioSamplesInterceptor;
import io.getstream.webrtc.flutter.utils.Callback;
import io.getstream.webrtc.flutter.utils.ConstraintsArray;
import io.getstream.webrtc.flutter.utils.ConstraintsMap;
import io.getstream.webrtc.flutter.utils.EglUtils;
import io.getstream.webrtc.flutter.utils.MediaConstraintsUtils;
import io.getstream.webrtc.flutter.utils.ObjectType;
import io.getstream.webrtc.flutter.utils.PermissionUtils;
import io.getstream.webrtc.flutter.videoEffects.VideoFrameProcessor;
import io.getstream.webrtc.flutter.videoEffects.VideoEffectProcessor;
import io.getstream.webrtc.flutter.videoEffects.ProcessorProvider;
import io.getstream.webrtc.flutter.video.LocalVideoTrack;
import io.getstream.webrtc.flutter.video.VideoCapturerInfo;

import org.webrtc.AudioSource;
import org.webrtc.AudioTrack;
import org.webrtc.Camera1Capturer;
import org.webrtc.Camera1Enumerator;
import org.webrtc.Camera1Helper;
import org.webrtc.Camera2Capturer;
import org.webrtc.Camera2Enumerator;
import org.webrtc.Camera2Helper;
import org.webrtc.CameraEnumerator;
import org.webrtc.CameraVideoCapturer;
import org.webrtc.CaptureSizeSelector;
import org.webrtc.MediaConstraints;
import org.webrtc.MediaStream;
import org.webrtc.MediaStreamTrack;
import org.webrtc.PeerConnectionFactory;
import org.webrtc.Size;
import org.webrtc.SurfaceTextureHelper;
import org.webrtc.VideoCapturer;
import org.webrtc.VideoSource;
import org.webrtc.VideoTrack;
import org.webrtc.audio.JavaAudioDeviceModule;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.RejectedExecutionException;
import java.util.stream.Collectors;

import io.flutter.plugin.common.MethodChannel.Result;

/**
 * The implementation of {@code getUserMedia} extracted into a separate file in order to reduce
 * complexity and to (somewhat) separate concerns.
 */
public class GetUserMediaImpl {
    private static final int DEFAULT_WIDTH = 1280;
    private static final int DEFAULT_HEIGHT = 720;
    private static final int DEFAULT_FPS = 30;

    private static final String EVENT_DISPLAY_MEDIA_STOPPED = "screenSharingStopped";
    private static final String PERMISSION_AUDIO = Manifest.permission.RECORD_AUDIO;
    private static final String PERMISSION_VIDEO = Manifest.permission.CAMERA;
    private static final String PERMISSION_SCREEN = "android.permission.MediaProjection";
    private static final int CAPTURE_PERMISSION_REQUEST_CODE = 1;
    private static final String GRANT_RESULTS = "GRANT_RESULT";
    private static final String PERMISSIONS = "PERMISSION";
    private static final String PROJECTION_DATA = "PROJECTION_DATA";
    private static final String RESULT_RECEIVER = "RESULT_RECEIVER";
    private static final String REQUEST_CODE = "REQUEST_CODE";
    private static final String FULL_SCREEN_ONLY = "FULL_SCREEN_ONLY";

    static final String TAG = FlutterWebRTCPlugin.TAG;

    private final Map<String, VideoCapturerInfoEx> mVideoCapturers = new HashMap<>();
    private final Map<String, SurfaceTextureHelper> mSurfaceTextureHelpers = new HashMap<>();
    private final Map<String, VideoSource> mVideoSources = new HashMap<>();
    private final Map<String, AudioSource> mAudioSources = new HashMap<>();

    /**
     * Opens cameras off the main thread. Creating the capturer and its
     * SurfaceTextureHelper, initialize, startCapture and the wait for the
     * camera to open are camera HAL work measured in hundreds of
     * milliseconds, and since Flutter 3.29 the main thread also runs Dart.
     * Single-threaded so a camera is released, and the owning factory freed,
     * behind any open still in flight; see {@link #freeFactoryAfterCameraOpens}.
     */
    private final ExecutorService cameraOpenExecutor =
            Executors.newSingleThreadExecutor(r -> new Thread(r, "CameraOpen"));

    /** Hands opened cameras back to the main thread, which owns the maps above. */
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    /**
     * Set by {@link #beginDispose} the moment disposal of the owning factory
     * is requested. New camera opens fail at once instead of queueing behind
     * the disposal. Main thread only.
     */
    private boolean disposing;

    /**
     * Camera work queued on {@link #cameraOpenExecutor} that has not reported
     * back to the main thread yet: opens, and releases of cameras that did
     * not become a track. Each uses the owning factory. Main thread only.
     */
    private int pendingCameraWork;

    /**
     * Frees the owning factory. Set when its dispose found camera work in
     * flight; run on the camera thread once {@link #pendingCameraWork} drops
     * to zero, so the main thread never waits for the camera and the factory
     * is never freed under it. Main thread only.
     */
    @Nullable
    private Runnable deferredFactoryFree;

    private final StateProvider stateProvider;
    private final Context applicationContext;

    static final int minAPILevel = Build.VERSION_CODES.LOLLIPOP;

    final AudioSamplesInterceptor inputSamplesInterceptor = new AudioSamplesInterceptor();
    private OutputAudioSamplesInterceptor outputSamplesInterceptor = null;
    JavaAudioDeviceModule audioDeviceModule;
    private final SparseArray<MediaRecorderImpl> mediaRecorders = new SparseArray<>();
    private AudioDeviceInfo preferredInput = null;
    private boolean isTorchOn;
    private Intent mediaProjectionData = null;

    private ScreenAudioCapturer screenAudioCapturer;
    private volatile boolean screenAudioEnabled = false;
    private OrientationAwareScreenCapturer currentScreenCapturer;

    private int audioChannelCount = 1;

    public void screenRequestPermissions(ResultReceiver resultReceiver) {
        screenRequestPermissions(resultReceiver, false);
    }

    public void screenRequestPermissions(ResultReceiver resultReceiver, boolean fullScreenOnly) {
        mediaProjectionData = null;
        final Activity activity = stateProvider.getActivity();
        if (activity == null) {
            // Activity went away, nothing we can do.
            return;
        }

        Bundle args = new Bundle();
        args.putParcelable(RESULT_RECEIVER, resultReceiver);
        args.putInt(REQUEST_CODE, CAPTURE_PERMISSION_REQUEST_CODE);
        args.putBoolean(FULL_SCREEN_ONLY, fullScreenOnly);

        ScreenRequestPermissionsFragment fragment = new ScreenRequestPermissionsFragment();
        fragment.setArguments(args);

        FragmentTransaction transaction =
                activity
                        .getFragmentManager()
                        .beginTransaction()
                        .add(fragment, fragment.getClass().getName());

        try {
            transaction.commit();
        } catch (IllegalStateException ise) {

        }
    }

    public void requestCapturePermission(final Result result) {
        requestCapturePermission(result, false);
    }

    public void requestCapturePermission(final Result result, final boolean fullScreenOnly) {
        screenRequestPermissions(
                new ResultReceiver(new Handler(Looper.getMainLooper())) {
                    @Override
                    protected void onReceiveResult(int requestCode, Bundle resultData) {
                        int resultCode = resultData.getInt(GRANT_RESULTS);
                        if (resultCode == Activity.RESULT_OK) {
                            mediaProjectionData = resultData.getParcelable(PROJECTION_DATA);
                            result.success(true);
                        } else {
                            result.success(false);
                        }
                    }
                },
                fullScreenOnly);
    }

    public static class ScreenRequestPermissionsFragment extends Fragment {

        private ResultReceiver resultReceiver = null;
        private int requestCode = 0;
        private int resultCode = 0;
        private boolean hasRequestedPermission = false;

        private void checkSelfPermissions(boolean requestPermissions) {
            // Avoid requesting permission multiple times
            if (hasRequestedPermission) {
                return;
            }

            if (resultCode != Activity.RESULT_OK) {
                Activity activity = this.getActivity();
                if (activity == null || activity.isFinishing()) {
                    return;
                }

                Bundle args = getArguments();
                if (args == null) {
                    return;
                }

                resultReceiver = args.getParcelable(RESULT_RECEIVER);
                requestCode = args.getInt(REQUEST_CODE);
                boolean fullScreenOnly = args.getBoolean(FULL_SCREEN_ONLY, false);

                hasRequestedPermission = true;

                // Post the permission request to allow the activity to fully stabilize.
                // This helps prevent the app from going to background on Samsung and other
                // devices when the MediaProjection permission dialog appears.
                new Handler(Looper.getMainLooper()).postDelayed(() -> {
                    Activity currentActivity = getActivity();
                    if (currentActivity != null && !currentActivity.isFinishing() && isAdded()) {
                        requestStart(currentActivity, requestCode, fullScreenOnly);
                    }
                }, 100);
            }
        }

        public void requestStart(Activity activity, int requestCode, boolean fullScreenOnly) {
            if (android.os.Build.VERSION.SDK_INT < minAPILevel) {
                Log.w(
                        TAG,
                        "Can't run requestStart() due to a low API level. API level 21 or higher is required.");
            } else {
                MediaProjectionManager mediaProjectionManager =
                        (MediaProjectionManager) activity.getSystemService(Context.MEDIA_PROJECTION_SERVICE);

                // On Android 14+ (API 34), opt in to capturing the entire display so the
                // consent dialog no longer offers the single-app option.
                Intent captureIntent;
                if (fullScreenOnly
                        && android.os.Build.VERSION.SDK_INT
                                >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                    captureIntent =
                            mediaProjectionManager.createScreenCaptureIntent(
                                    MediaProjectionConfig.createConfigForDefaultDisplay());
                } else {
                    captureIntent = mediaProjectionManager.createScreenCaptureIntent();
                }

                // call for the projection manager
                this.startActivityForResult(captureIntent, requestCode);
            }
        }

        @Override
        public void onActivityResult(int requestCode, int resultCode, Intent data) {
            super.onActivityResult(requestCode, resultCode, data);
            resultCode = resultCode;
            String[] permissions;
            if (resultCode != Activity.RESULT_OK) {
                finish();
                Bundle resultData = new Bundle();
                resultData.putString(PERMISSIONS, PERMISSION_SCREEN);
                resultData.putInt(GRANT_RESULTS, resultCode);
                resultReceiver.send(requestCode, resultData);
                return;
            }
            Bundle resultData = new Bundle();
            resultData.putString(PERMISSIONS, PERMISSION_SCREEN);
            resultData.putInt(GRANT_RESULTS, resultCode);
            resultData.putParcelable(PROJECTION_DATA, data);
            resultReceiver.send(requestCode, resultData);
            finish();
        }

        private void finish() {
            Activity activity = getActivity();
            if (activity != null) {
                activity.getFragmentManager().beginTransaction().remove(this).commitAllowingStateLoss();
            }
        }

        @Override
        public void onResume() {
            super.onResume();
            checkSelfPermissions(/* requestPermissions */ true);
        }
    }

    GetUserMediaImpl(StateProvider stateProvider, Context applicationContext) {
        this.stateProvider = stateProvider;
        this.applicationContext = applicationContext;
    }

    /**
     * Per-call factory. All track/source creation routes through it.
     * This field must always be set before any media operation runs.
     */
    @Nullable
    private PeerConnectionFactory peerConnectionFactory;

    void setPeerConnectionFactory(@NonNull PeerConnectionFactory peerConnectionFactory) {
        this.peerConnectionFactory = peerConnectionFactory;
    }

    private PeerConnectionFactory peerConnectionFactory() {
        if (peerConnectionFactory == null) {
            throw new IllegalStateException(
                    "GetUserMediaImpl: peerConnectionFactory is not set. "
                            + "Was setPeerConnectionFactory() called on this instance?");
        }
        return peerConnectionFactory;
    }

    void setAudioChannelCount(int channelCount) {
        this.audioChannelCount = channelCount;
    }

    static private void resultError(String method, String error, Result result) {
        String errorMsg = method + "(): " + error;
        result.error(method, errorMsg, null);
        Log.d(TAG, errorMsg);
    }

    /**
     * Includes default constraints set for the audio media type.
     *
     * @param audioConstraints <tt>MediaConstraints</tt> instance to be filled with the default
     *                         constraints for audio media type.
     */
    private void addDefaultAudioConstraints(MediaConstraints audioConstraints) {
        audioConstraints.optional.add(
                new MediaConstraints.KeyValuePair("googNoiseSuppression", "true"));
        audioConstraints.optional.add(
                new MediaConstraints.KeyValuePair("googEchoCancellation", "true"));
        audioConstraints.optional.add(new MediaConstraints.KeyValuePair("echoCancellation", "true"));
        audioConstraints.optional.add(
                new MediaConstraints.KeyValuePair("googEchoCancellation2", "true"));
        audioConstraints.optional.add(
                new MediaConstraints.KeyValuePair("googDAEchoCancellation", "true"));
    }

    /**
     * Create video capturer via given facing mode
     *
     * @param enumerator a <tt>CameraEnumerator</tt> provided by webrtc it can be Camera1Enumerator or
     *                   Camera2Enumerator
     * @param isFacing   'user' mapped with 'front' is true (default) 'environment' mapped with 'back'
     *                   is false
     * @param sourceId   (String) use this sourceId and ignore facing mode if specified.
     * @return Pair of deviceName to VideoCapturer. Can invoke with <tt>startCapture</tt>/<tt>stopCapture</tt> <tt>null</tt>
     * if not matched camera with specified facing mode.
     */
    private Pair<String, VideoCapturer> createVideoCapturer(
            CameraEnumerator enumerator, boolean isFacing, String sourceId, CameraEventsHandler cameraEventsHandler) {
        VideoCapturer videoCapturer;
        // if sourceId given, use specified sourceId first
        final String[] deviceNames = enumerator.getDeviceNames();
        if (sourceId != null && !sourceId.equals("")) {
            for (String name : deviceNames) {
                if (name.equals(sourceId)) {
                    videoCapturer = enumerator.createCapturer(name, cameraEventsHandler);
                    if (videoCapturer != null) {
                        Log.d(TAG, "create user specified camera " + name + " succeeded");
                        return new Pair<>(name, videoCapturer);
                    } else {
                        Log.d(TAG, "create user specified camera " + name + " failed");
                        break; // fallback to facing mode
                    }
                }
            }
        }

        // otherwise, use facing mode
        String facingStr = isFacing ? "front" : "back";
        for (String name : deviceNames) {
            if (enumerator.isFrontFacing(name) == isFacing) {
                videoCapturer = enumerator.createCapturer(name, cameraEventsHandler);
                if (videoCapturer != null) {
                    Log.d(TAG, "Create " + facingStr + " camera " + name + " succeeded");

                    return new Pair<>(name, videoCapturer);
                } else {
                    Log.e(TAG, "Create " + facingStr + " camera " + name + " failed");
                }
            }
        }

        // falling back to the first available camera
        if (deviceNames.length > 0) {
            videoCapturer = enumerator.createCapturer(deviceNames[0], cameraEventsHandler);
            Log.d(TAG, "Falling back to the first available camera");
            return new Pair<>(deviceNames[0], videoCapturer);
        }

        return null;
    }

    /**
     * Retrieves "facingMode" constraint value.
     *
     * @param mediaConstraints a <tt>ConstraintsMap</tt> which represents "GUM" constraints argument.
     * @return String value of "facingMode" constraints in "GUM" or <tt>null</tt> if not specified.
     */
    private String getFacingMode(ConstraintsMap mediaConstraints) {
        return mediaConstraints == null ? null : mediaConstraints.getString("facingMode");
    }

    /**
     * Retrieves "sourceId" constraint value.
     *
     * @param mediaConstraints a <tt>ConstraintsMap</tt> which represents "GUM" constraints argument
     * @return String value of "sourceId" optional "GUM" constraint or <tt>null</tt> if not specified.
     */
    private String getSourceIdConstraint(ConstraintsMap mediaConstraints) {
        if (mediaConstraints != null
                && mediaConstraints.hasKey("deviceId")) {
            return mediaConstraints.getString("deviceId");
        }
        if (mediaConstraints != null
                && mediaConstraints.hasKey("optional")
                && mediaConstraints.getType("optional") == ObjectType.Array) {
            ConstraintsArray optional = mediaConstraints.getArray("optional");

            for (int i = 0, size = optional.size(); i < size; i++) {
                if (optional.getType(i) == ObjectType.Map) {
                    ConstraintsMap option = optional.getMap(i);

                    if (option.hasKey("sourceId") && option.getType("sourceId") == ObjectType.String) {
                        return option.getString("sourceId");
                    }
                }
            }
        }

        return null;
    }

    private ConstraintsMap getUserAudio(ConstraintsMap constraints, MediaStream stream) {
        AudioSwitchManager.instance.start();
        MediaConstraints audioConstraints = new MediaConstraints();
        String deviceId = null;
        if (constraints.getType("audio") == ObjectType.Boolean) {
            addDefaultAudioConstraints(audioConstraints);
        } else if (constraints.getType("audio") == ObjectType.Map) {
            audioConstraints = MediaConstraintsUtils.parseMediaConstraints(constraints.getMap("audio"));
            deviceId = getSourceIdConstraint(constraints.getMap("audio"));
        } else {
            // Fallback for null or unexpected types
            addDefaultAudioConstraints(audioConstraints);
        }

        Log.i(TAG, "getUserMedia(audio): " + audioConstraints);

        String trackId = stateProvider.getNextTrackUUID();
        PeerConnectionFactory pcFactory = peerConnectionFactory();
        AudioSource audioSource = pcFactory.createAudioSource(audioConstraints);

        mAudioSources.put(trackId, audioSource);

        AudioTrack track = pcFactory.createAudioTrack(trackId, audioSource);
        stream.addTrack(track);

        stateProvider.putLocalTrack(track.id(), new LocalAudioTrack(track));

        ConstraintsMap trackParams = new ConstraintsMap();
        trackParams.putBoolean("enabled", track.enabled());
        trackParams.putString("id", track.id());
        trackParams.putString("kind", "audio");
        trackParams.putString("label", track.id());
        trackParams.putString("readyState", track.state().toString());
        trackParams.putBoolean("remote", false);

        if (deviceId == null) {
            if (VERSION.SDK_INT >= VERSION_CODES.M) {
                deviceId = "" + getPreferredInputDevice(preferredInput);
            }
        }

        ConstraintsMap settings = new ConstraintsMap();
        settings.putString("deviceId", deviceId);
        settings.putString("kind", "audioinput");
        settings.putBoolean("autoGainControl", true);
        settings.putBoolean("echoCancellation", true);
        settings.putBoolean("noiseSuppression", true);
        settings.putInt("channelCount", 1);
        settings.putInt("latency", 0);
        trackParams.putMap("settings", settings.toMap());

        return trackParams;
    }

    /**
     * Implements {@code getUserMedia} without knowledge whether the necessary permissions have
     * already been granted. If the necessary permissions have not been granted yet, they will be
     * requested.
     */
    void getUserMedia(
            final ConstraintsMap constraints, final Result result, final MediaStream mediaStream) {

        final ArrayList<String> requestPermissions = new ArrayList<>();

        if (constraints.hasKey("audio")) {
            switch (constraints.getType("audio")) {
                case Boolean:
                    if (constraints.getBoolean("audio")) {
                        requestPermissions.add(PERMISSION_AUDIO);
                    }
                    break;
                case Map:
                    requestPermissions.add(PERMISSION_AUDIO);
                    break;
                default:
                    break;
            }
        }

        if (constraints.hasKey("video")) {
            switch (constraints.getType("video")) {
                case Boolean:
                    if (constraints.getBoolean("video")) {
                        requestPermissions.add(PERMISSION_VIDEO);
                    }
                    break;
                case Map:
                    requestPermissions.add(PERMISSION_VIDEO);
                    break;
                default:
                    break;
            }
        }

        // According to step 2 of the getUserMedia() algorithm,
        // requestedMediaTypes is the set of media types in constraints with
        // either a dictionary value or a value of "true".
        // According to step 3 of the getUserMedia() algorithm, if
        // requestedMediaTypes is the empty set, the method invocation fails
        // with a TypeError.
        if (requestPermissions.isEmpty()) {
            resultError("getUserMedia", "TypeError, constraints requests no media types", result);
            return;
        }

        /// Only systems pre-M, no additional permission request is needed.
        if (VERSION.SDK_INT < VERSION_CODES.M) {
            getUserMedia(constraints, result, mediaStream, requestPermissions);
            return;
        }

        requestPermissions(
                requestPermissions,
                /* successCallback */ new Callback() {
                    @Override
                    public void invoke(Object... args) {
                        List<String> grantedPermissions = (List<String>) args[0];

                        getUserMedia(constraints, result, mediaStream, grantedPermissions);
                    }
                },
                /* errorCallback */ new Callback() {
                    @Override
                    public void invoke(Object... args) {
                        // According to step 10 Permission Failure of the
                        // getUserMedia() algorithm, if the user has denied
                        // permission, fail "with a new DOMException object whose
                        // name attribute has the value NotAllowedError."
                        resultError("getUserMedia", "DOMException, NotAllowedError", result);
                    }
                });
    }

    void getDisplayMedia(
            final ConstraintsMap constraints, final Result result, final MediaStream mediaStream) {
        // Check if audio is requested for screen share
        final boolean includeAudio = parseIncludeAudio(constraints);

        if (mediaProjectionData == null) {
            screenRequestPermissions(
                    new ResultReceiver(new Handler(Looper.getMainLooper())) {
                        @Override
                        protected void onReceiveResult(int requestCode, Bundle resultData) {
                            Intent mediaProjectionData = resultData.getParcelable(PROJECTION_DATA);
                            int resultCode = resultData.getInt(GRANT_RESULTS);

                            if (resultCode != Activity.RESULT_OK) {
                                resultError("screenRequestPermissions", "User didn't give permission to capture the screen.", result);
                                return;
                            }
                            getDisplayMedia(result, mediaStream, mediaProjectionData, includeAudio);
                        }
                    });
        } else {
            getDisplayMedia(result, mediaStream, mediaProjectionData, includeAudio);
        }
    }

    /**
     * Parses the includeAudio flag from constraints.
     * Checks for audio: true or audio: { ... } in constraints.
     */
    private boolean parseIncludeAudio(ConstraintsMap constraints) {
        if (constraints == null || !constraints.hasKey("audio")) {
            return false;
        }

        ObjectType audioType = constraints.getType("audio");
        if (audioType == ObjectType.Boolean) {
            return constraints.getBoolean("audio");
        } else if (audioType == ObjectType.Map) {
            // If audio is a map/object, we treat it as audio enabled
            return true;
        }

        return false;
    }

    private void getDisplayMedia(final Result result, final MediaStream mediaStream,
            final Intent mediaProjectionData, final boolean includeAudio) {
        /* Create ScreenCapture */
        VideoTrack displayTrack = null;
        String trackId = stateProvider.getNextTrackUUID();

        OrientationAwareScreenCapturer videoCapturer = new OrientationAwareScreenCapturer(
                applicationContext,
                mediaProjectionData,
                new MediaProjection.Callback() {
                    @Override
                    public void onStop() {
                        super.onStop();

                        // Stop screen audio capture when screen sharing stops
                        stopScreenAudioCapture();

                        ConstraintsMap params = new ConstraintsMap();
                        params.putString("event", EVENT_DISPLAY_MEDIA_STOPPED);
                        params.putString("trackId", trackId);
                        FlutterWebRTCPlugin.sharedSingleton.sendEvent(params.toMap());
                    }
                });

        // Set up screen audio capture listener if audio is requested
        if (includeAudio && ScreenAudioCapturer.isSupported()) {
            videoCapturer.setMediaProjectionReadyListener(
                    new OrientationAwareScreenCapturer.MediaProjectionReadyListener() {
                        @Override
                        public void onMediaProjectionReady(MediaProjection mediaProjection) {
                            startScreenAudioCapture(mediaProjection);
                        }

                        @Override
                        public void onMediaProjectionStopped() {
                            stopScreenAudioCapture();
                        }
                    });
        }

        currentScreenCapturer = videoCapturer;

        PeerConnectionFactory pcFactory = peerConnectionFactory();
        VideoSource videoSource = pcFactory.createVideoSource(true);

        String threadName = Thread.currentThread().getName() + "_texture_screen_thread";
        SurfaceTextureHelper surfaceTextureHelper =
                SurfaceTextureHelper.create(threadName, EglUtils.getRootEglBaseContext());
        videoCapturer.initialize(
                surfaceTextureHelper, applicationContext, videoSource.getCapturerObserver());

        WindowManager wm =
                (WindowManager) applicationContext.getSystemService(Context.WINDOW_SERVICE);

        Display display = wm.getDefaultDisplay();
        Point size = new Point();
        display.getRealSize(size);

        VideoCapturerInfoEx info = new VideoCapturerInfoEx();
        info.width = size.x;
        info.height = size.y;
        info.fps = DEFAULT_FPS;
        info.isScreenCapture = true;
        info.capturer = videoCapturer;

        videoCapturer.startCapture(info.width, info.height, info.fps);
        Log.d(TAG, "OrientationAwareScreenCapturer.startCapture: " + info.width + "x" + info.height + "@" + info.fps +
                ", includeAudio: " + includeAudio);

        mVideoCapturers.put(trackId, info);
        mVideoSources.put(trackId, videoSource);

        displayTrack = pcFactory.createVideoTrack(trackId, videoSource);

        ConstraintsArray audioTracks = new ConstraintsArray();
        ConstraintsArray videoTracks = new ConstraintsArray();
        ConstraintsMap successResult = new ConstraintsMap();

        if (displayTrack  != null) {
            String id = displayTrack.id();

            LocalVideoTrack displayLocalVideoTrack = new LocalVideoTrack(displayTrack);
            videoSource.setVideoProcessor(displayLocalVideoTrack);

            stateProvider.putLocalTrack(id, displayLocalVideoTrack);

            ConstraintsMap track_ = new ConstraintsMap();
            String kind = displayTrack.kind();

            track_.putBoolean("enabled", displayTrack.enabled());
            track_.putString("id", id);
            track_.putString("kind", kind);
            track_.putString("label", kind);
            track_.putString("readyState", displayTrack.state().toString());
            track_.putBoolean("remote", false);

            videoTracks.pushMap(track_);
            mediaStream.addTrack(displayTrack);
        }

        String streamId = mediaStream.getId();

        Log.d(TAG, "MediaStream id: " + streamId);
        stateProvider.putLocalStream(streamId, mediaStream);
        successResult.putString("streamId", streamId);
        successResult.putArray("audioTracks", audioTracks.toArrayList());
        successResult.putArray("videoTracks", videoTracks.toArrayList());
        result.success(successResult.toMap());
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    private void startScreenAudioCapture(MediaProjection mediaProjection) {
        if (!ScreenAudioCapturer.isSupported()) {
            Log.w(TAG, "Screen audio capture not supported on this device");
            return;
        }

        if (screenAudioCapturer == null) {
            screenAudioCapturer = new ScreenAudioCapturer(applicationContext, audioChannelCount);
        }

        boolean started = screenAudioCapturer.startCapture(mediaProjection);
        screenAudioEnabled = started;

        if (started) {
            Log.d(TAG, "Screen audio capture started successfully");
        } else {
            Log.w(TAG, "Failed to start screen audio capture");
        }
    }

    private synchronized void stopScreenAudioCapture() {
        screenAudioEnabled = false;

        ScreenAudioCapturer localCapturer = screenAudioCapturer;
        if (localCapturer != null) {
            localCapturer.stopCapture();
            Log.d(TAG, "Screen audio capture stopped");
        }
    }

    /**
     * Returns whether screen audio capture is currently enabled.
     */
    public boolean isScreenAudioEnabled() {
        return screenAudioEnabled && screenAudioCapturer != null && screenAudioCapturer.isCapturing();
    }

    /**
     * Gets screen audio bytes for mixing with microphone audio.
     * Returns null if screen audio capture is not active.
     */
    public ByteBuffer getScreenAudioBytes(int bytesRequested) {
        if (!isScreenAudioEnabled()) {
            return null;
        }
        
        return screenAudioCapturer.getScreenAudioBytes(bytesRequested);
    }

    /**
     * Implements {@code getUserMedia} with the knowledge that the necessary permissions have already
     * been granted. If the necessary permissions have not been granted yet, they will NOT be
     * requested.
     *
     * The audio track is created here, on the main thread. The camera is opened on
     * {@link #cameraOpenExecutor} and its track is created back on the main thread, which owns
     * the capturer, texture helper and video source maps and the {@code result}.
     */
    private void getUserMedia(
            ConstraintsMap constraints,
            Result result,
            MediaStream mediaStream,
            List<String> grantedPermissions) {
        final ConstraintsMap audioParams;
        if (grantedPermissions.contains(PERMISSION_AUDIO)) {
            audioParams = getUserAudio(constraints, mediaStream);
            if (audioParams == null) {
                failGetUserMedia(mediaStream, result);
                return;
            }
        } else {
            audioParams = null;
        }

        if (!grantedPermissions.contains(PERMISSION_VIDEO)) {
            succeedGetUserMedia(audioParams, null, mediaStream, result);
            return;
        }

        if (disposing) {
            Log.w(TAG, "getUserMedia(video): factory is being disposed");
            failGetUserMedia(mediaStream, result);
            return;
        }

        pendingCameraWork++;
        try {
            cameraOpenExecutor.execute(() -> {
                OpenedCamera camera = null;
                Throwable error = null;
                try {
                    camera = openCamera(constraints);
                } catch (Throwable t) {
                    error = t;
                }
                final OpenedCamera openedCamera = camera;
                final Throwable openError = error;
                mainHandler.post(() -> onCameraOpened(
                        openedCamera, openError, audioParams, mediaStream, result));
            });
        } catch (RejectedExecutionException e) {
            pendingCameraWork--;
            Log.w(TAG, "getUserMedia(video): camera open rejected, factory is disposed");
            failGetUserMedia(mediaStream, result);
        }
    }

    /**
     * Completes a {@code getUserMedia} whose camera open finished. Main thread
     * only. A camera that does not become a track is released through
     * {@link #releaseCamera}, which keeps it counted as pending work, and the
     * open itself is signed off with {@link #onCameraWorkDone} last.
     */
    private void onCameraOpened(
            @Nullable OpenedCamera camera,
            @Nullable Throwable openError,
            @Nullable ConstraintsMap audioParams,
            MediaStream mediaStream,
            Result result) {
        if (deferredFactoryFree != null) {
            // The factory's dispose is waiting on this open: the camera must
            // not become a track. The stream's tracks are left alone, the
            // disposal evicted them already.
            if (camera != null) {
                releaseCamera(camera);
            }
            onCameraWorkDone();
            resultError("getUserMedia", "Failed to create new track, factory is disposed.", result);
            return;
        }

        if (camera == null) {
            if (openError != null) {
                Log.e(TAG, "getUserMedia(video): opening the camera failed", openError);
            }
            onCameraWorkDone();
            failGetUserMedia(mediaStream, result);
            return;
        }

        final ConstraintsMap videoParams;
        try {
            videoParams = attachVideo(camera, mediaStream);
        } catch (Throwable t) {
            Log.e(TAG, "getUserMedia(video): creating the video track failed", t);
            releaseCamera(camera);
            onCameraWorkDone();
            failGetUserMedia(mediaStream, result);
            return;
        }
        onCameraWorkDone();
        succeedGetUserMedia(audioParams, videoParams, mediaStream, result);
    }

    /**
     * Releases a camera that did not become a track, on the camera thread:
     * closing it blocks until the HAL is done, and it still delivers to a
     * video source on the owning factory. Counted as pending work until it
     * has finished, so a factory dispose landing meanwhile defers the free
     * behind it. Main thread only.
     */
    private void releaseCamera(OpenedCamera camera) {
        pendingCameraWork++;
        final Runnable release = () -> {
            try {
                camera.release();
            } finally {
                mainHandler.post(this::onCameraWorkDone);
            }
        };
        try {
            cameraOpenExecutor.execute(release);
        } catch (RejectedExecutionException e) {
            // Not reachable: the executor is only shut down with nothing pending.
            new Thread(release, "CameraRelease").start();
        }
    }

    /**
     * Signs off one unit of camera work. Main thread only. Once nothing is
     * pending, a factory free deferred by {@link #freeFactoryAfterCameraOpens}
     * runs on the camera thread, behind every release queued there, and the
     * executor shuts down after it.
     */
    private void onCameraWorkDone() {
        pendingCameraWork--;
        if (pendingCameraWork > 0 || deferredFactoryFree == null) {
            return;
        }
        final Runnable free = deferredFactoryFree;
        deferredFactoryFree = null;
        cameraOpenExecutor.execute(() -> {
            free.run();
            cameraOpenExecutor.shutdown();
        });
    }

    /** Fails {@code getUserMedia}, disposing the tracks already added to the stream. */
    private void failGetUserMedia(MediaStream mediaStream, Result result) {
        for (MediaStreamTrack track : mediaStream.audioTracks) {
            if (track != null) {
                track.dispose();
            }
        }
        for (MediaStreamTrack track : mediaStream.videoTracks) {
            if (track != null) {
                track.dispose();
            }
        }
        // XXX The following does not follow the getUserMedia() algorithm
        // specified by
        // https://www.w3.org/TR/mediacapture-streams/#dom-mediadevices-getusermedia
        // with respect to distinguishing the various causes of failure.
        resultError("getUserMedia", "Failed to create new track.", result);
    }

    /** Registers the stream and replies to {@code getUserMedia} with its tracks. */
    private void succeedGetUserMedia(
            @Nullable ConstraintsMap audioParams,
            @Nullable ConstraintsMap videoParams,
            MediaStream mediaStream,
            Result result) {
        ConstraintsArray audioTracks = new ConstraintsArray();
        ConstraintsArray videoTracks = new ConstraintsArray();
        ConstraintsMap successResult = new ConstraintsMap();

        if (audioParams != null) {
            audioTracks.pushMap(audioParams);
        }
        if (videoParams != null) {
            videoTracks.pushMap(videoParams);
        }

        String streamId = mediaStream.getId();
        Log.d(TAG, "MediaStream id: " + streamId);
        stateProvider.putLocalStream(streamId, mediaStream);

        successResult.putString("streamId", streamId);
        successResult.putArray("audioTracks", audioTracks.toArrayList());
        successResult.putArray("videoTracks", videoTracks.toArrayList());
        result.success(successResult.toMap());
    }

    /**
     * Stops accepting camera opens. Called on the main thread as soon as
     * disposal of the owning factory is requested, so a {@code getUserMedia}
     * arriving before the disposal lands fails at once rather than opening a
     * camera the disposal then has to wait for.
     */
    void beginDispose() {
        disposing = true;
    }

    /**
     * Called by the owning factory's dispose, on the main thread. Camera work
     * in flight, an open or a release, uses that factory, so the factory must
     * not be freed under it. With nothing pending the executor is shut down
     * and this returns true: the caller frees the factory now. Otherwise
     * {@code free} runs on the camera thread once the pending work is done,
     * and this returns false.
     */
    boolean freeFactoryAfterCameraOpens(Runnable free) {
        disposing = true;
        if (pendingCameraWork == 0) {
            cameraOpenExecutor.shutdown();
            return true;
        }
        deferredFactoryFree = free;
        return false;
    }

    /** A camera opened on {@link #cameraOpenExecutor}, waiting to become a track on the main thread. */
    private static final class OpenedCamera {
        final VideoCapturerInfoEx info;
        final SurfaceTextureHelper surfaceTextureHelper;
        final VideoSource videoSource;
        final String deviceId;
        @Nullable
        final String facingMode;
        final int sensorOrientation;
        /** The capture format the camera opened, in sensor space; null when no supported sizes were found. */
        @Nullable
        final Size captureSize;

        OpenedCamera(
                VideoCapturerInfoEx info,
                SurfaceTextureHelper surfaceTextureHelper,
                VideoSource videoSource,
                String deviceId,
                @Nullable String facingMode,
                int sensorOrientation,
                @Nullable Size captureSize) {
            this.info = info;
            this.surfaceTextureHelper = surfaceTextureHelper;
            this.videoSource = videoSource;
            this.deviceId = deviceId;
            this.facingMode = facingMode;
            this.sensorOrientation = sensorOrientation;
            this.captureSize = captureSize;
        }

        /** Closes the camera and frees the capturer and texture helper, as removeVideoCapturer does. */
        void release() {
            try {
                info.capturer.stopCapture();
                info.cameraEventsHandler.waitForCameraClosed();
            } catch (InterruptedException e) {
                Log.e(TAG, "release() Failed to stop video capturer");
            } finally {
                info.capturer.dispose();
                surfaceTextureHelper.stopListening();
                surfaceTextureHelper.dispose();
            }
        }
    }

    /**
     * @return Returns the integer at the key, or the `ideal` property if it is a map.
     */
    @Nullable
    private Integer getConstrainInt(@Nullable ConstraintsMap constraintsMap, String key) {
        if (constraintsMap == null) {
            return null;
        }

        if (constraintsMap.getType(key) == ObjectType.Number) {
            try {
                return constraintsMap.getInt(key);
            } catch (Exception e) {
                // Could be a double instead
                return (int) Math.round(constraintsMap.getDouble(key));
            }
        }

        if (constraintsMap.getType(key) == ObjectType.String) {
            try {
                return Integer.parseInt(constraintsMap.getString(key));
            } catch (Exception e) {
                // Could be a double instead
                return (int) Math.round(Double.parseDouble(constraintsMap.getString(key)));
            }
        }

        if (constraintsMap.getType(key) == ObjectType.Map) {
            ConstraintsMap innerMap = constraintsMap.getMap(key);
            if (constraintsMap.getType("ideal") == ObjectType.Number) {
                return innerMap.getInt("ideal");
            }
        }

        return null;
    }

    public ConstraintsMap cloneTrack(String trackId) {
        String newTrackId = stateProvider.getNextTrackUUID();
        LocalTrack originalLocalTrack = stateProvider.getLocalTrack(trackId);

        PeerConnectionFactory pcFactory = peerConnectionFactory();
        ConstraintsMap trackParams = new ConstraintsMap();

        if (originalLocalTrack instanceof LocalVideoTrack) {
            VideoSource videoSource = mVideoSources.get(trackId);

            mSurfaceTextureHelpers.put(newTrackId, mSurfaceTextureHelpers.get(trackId));
            mVideoSources.put(newTrackId, videoSource);

            VideoTrack track = pcFactory.createVideoTrack(newTrackId, videoSource);
            LocalVideoTrack localVideoTrack = new LocalVideoTrack(track);

            videoSource.setVideoProcessor(localVideoTrack);
            stateProvider.putLocalTrack(track.id(),localVideoTrack);

            trackParams.putBoolean("enabled", track.enabled());
            trackParams.putString("kind", "video");
            trackParams.putString("readyState", track.state().toString());
        } else {
            AudioSource audioSource = mAudioSources.get(trackId);
            mAudioSources.put(newTrackId, audioSource);

            AudioTrack track = pcFactory.createAudioTrack(newTrackId, audioSource);

            stateProvider.putLocalTrack(track.id(), new LocalAudioTrack(track));

            trackParams.putBoolean("enabled", track.enabled());
            trackParams.putString("kind", "audio");
            trackParams.putString("readyState", track.state().toString());
        }

        trackParams.putString("id", newTrackId);
        trackParams.putString("label", newTrackId);
        trackParams.putBoolean("remote", false);

        return trackParams;
    }

    /**
     * Opens the camera described by {@code constraints}. Runs on
     * {@link #cameraOpenExecutor}: everything here is camera HAL work, and
     * none of it touches the per-track maps. Returns null only when no
     * capturer or texture helper could be created. Otherwise it returns once
     * the camera delivers its first frame, reports an error, or the wait
     * times out, so a camera that failed to open still comes back and
     * becomes a track, as it always has.
     */
    @Nullable
    private OpenedCamera openCamera(ConstraintsMap constraints) {
        ConstraintsMap videoConstraintsMap = null;
        ConstraintsMap videoConstraintsMandatory = null;
        if (constraints.getType("video") == ObjectType.Map) {
            videoConstraintsMap = constraints.getMap("video");
            if (videoConstraintsMap.hasKey("mandatory")
                    && videoConstraintsMap.getType("mandatory") == ObjectType.Map) {
                videoConstraintsMandatory = videoConstraintsMap.getMap("mandatory");
            }
        }

        Log.i(TAG, "getUserMedia(video): " + videoConstraintsMap);

        // NOTE: to support Camera2, the device should:
        //   1. Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP
        //   2. all camera support level should greater than LEGACY
        //   see:
        // https://developer.android.com/reference/android/hardware/camera2/CameraCharacteristics.html#INFO_SUPPORTED_HARDWARE_LEVEL
        // TODO Enable camera2 enumerator
        CameraEnumerator cameraEnumerator;

        if (Camera2Enumerator.isSupported(applicationContext)) {
            Log.d(TAG, "Creating video capturer using Camera2 API.");
            cameraEnumerator = new Camera2Enumerator(applicationContext);
        } else {
            Log.d(TAG, "Creating video capturer using Camera1 API.");
            cameraEnumerator = new Camera1Enumerator(false);
        }

        String facingMode = getFacingMode(videoConstraintsMap);
        boolean isFacing = facingMode == null || !facingMode.equals("environment");
        String deviceId = getSourceIdConstraint(videoConstraintsMap);
        CameraEventsHandler cameraEventsHandler = new CameraEventsHandler();
        Pair<String, VideoCapturer> result = createVideoCapturer(cameraEnumerator, isFacing, deviceId, cameraEventsHandler);

        if (result == null) {
            return null;
        }

        deviceId = result.first;
        VideoCapturer videoCapturer = result.second;

        if (cameraEnumerator.isFrontFacing(deviceId)) {
            facingMode = "user";
        } else if (cameraEnumerator.isBackFacing(deviceId)) {
            facingMode = "environment";
        }
        // else, leave facingMode as it was (for non-standard cameras)

        PeerConnectionFactory pcFactory = peerConnectionFactory();
        VideoSource videoSource = pcFactory.createVideoSource(false);
        String threadName = Thread.currentThread().getName() + "_texture_camera_thread";
        SurfaceTextureHelper surfaceTextureHelper =
                SurfaceTextureHelper.create(threadName, EglUtils.getRootEglBaseContext());

        if (surfaceTextureHelper == null) {
            Log.e(TAG, "surfaceTextureHelper is null");
            videoCapturer.dispose();
            videoSource.dispose();
            return null;
        }

        videoCapturer.initialize(
                surfaceTextureHelper, applicationContext, videoSource.getCapturerObserver());

        VideoCapturerInfoEx info = new VideoCapturerInfoEx();

        Integer videoWidth = getConstrainInt(videoConstraintsMap, "width");
        int targetWidth = videoWidth != null
                ? videoWidth
                : videoConstraintsMandatory != null && videoConstraintsMandatory.hasKey("minWidth")
                ? videoConstraintsMandatory.getInt("minWidth")
                : DEFAULT_WIDTH;

        Integer videoHeight = getConstrainInt(videoConstraintsMap, "height");
        int targetHeight = videoHeight != null
                ? videoHeight
                : videoConstraintsMandatory != null && videoConstraintsMandatory.hasKey("minHeight")
                ? videoConstraintsMandatory.getInt("minHeight")
                : DEFAULT_HEIGHT;

        Integer videoFrameRate = getConstrainInt(videoConstraintsMap, "frameRate");
        int targetFps = videoFrameRate != null
                ? videoFrameRate
                : videoConstraintsMandatory != null && videoConstraintsMandatory.hasKey("minFrameRate")
                ? videoConstraintsMandatory.getInt("minFrameRate")
                : DEFAULT_FPS;

        info.width = targetWidth;
        info.height = targetHeight;
        info.fps = targetFps;
        info.capturer = videoCapturer;
        info.cameraName = deviceId;
        info.isFrontFacing = cameraEnumerator.isFrontFacing(deviceId);

        // Choose the capture format ourselves, keeping the requested aspect ratio, and ask the
        // capturer for exactly that size. Left to itself the capturer takes libwebrtc's closest
        // size by summed edge difference, which prefers a camera's 2:1 format over its 16:9 ones
        // for a 2560x1440 request (Pixel 6a and Pixel 8 opened 2560x1280 that way).
        List<Size> supportedSizes = null;
        Size actualSize = null;
        int sensorOrientation = -1;
        if (videoCapturer instanceof Camera1Capturer) {
            int cameraId = Camera1Helper.getCameraId(deviceId);
            supportedSizes = Camera1Helper.getSupportedSizes(cameraId);
            sensorOrientation = Camera1Helper.getSensorOrientation(cameraId);
        } else if (videoCapturer instanceof Camera2Capturer) {
            CameraManager cameraManager = (CameraManager) applicationContext.getSystemService(Context.CAMERA_SERVICE);
            supportedSizes = Camera2Helper.getSupportedSizes(cameraManager, deviceId);
            sensorOrientation = Camera2Helper.getSensorOrientation(cameraManager, deviceId);
        }
        actualSize = CaptureSizeSelector.select(supportedSizes, targetWidth, targetHeight);
        if (sensorOrientation < 0) {
            Log.w(TAG, "Sensor orientation unavailable for camera " + deviceId + "; reporting the capture size unrotated");
        }

        int captureWidth = targetWidth;
        int captureHeight = targetHeight;
        if (actualSize != null) {
            captureWidth = actualSize.width;
            captureHeight = actualSize.height;
            info.width = actualSize.width;
            info.height = actualSize.height;
        }

        // One line per capture start with the whole size decision, at info so a profile build's
        // logcat shows it: the request, every format the camera offers, and what was opened.
        Log.i(TAG, "Camera " + deviceId + " capture: requested " + targetWidth + "x" + targetHeight + "@" + targetFps
                + ", supported [" + CaptureSizeSelector.describe(supportedSizes) + "]"
                + ", opening " + captureWidth + "x" + captureHeight
                + " (sensor orientation " + sensorOrientation + ")");

        info.cameraEventsHandler = cameraEventsHandler;
        // The capturer applies libwebrtc's closest-size rule to this request; an exact supported
        // size is found at difference 0, so the camera opens the format chosen above.
        videoCapturer.startCapture(captureWidth, captureHeight, targetFps);

        cameraEventsHandler.waitForCameraOpen();

        Log.d(TAG, "Target: " + targetWidth + "x" + targetHeight + "@" + targetFps + ", Actual: " + info.width + "x" + info.height + "@" + info.fps);

        return new OpenedCamera(info, surfaceTextureHelper, videoSource, deviceId, facingMode, sensorOrientation, actualSize);
    }

    /**
     * Registers an opened camera and creates its track. Main thread only: it
     * registers the local track and writes the capturer, texture helper and
     * video source maps, last, so a failure leaves no entry behind for the
     * camera the caller then releases.
     */
    private ConstraintsMap attachVideo(OpenedCamera camera, MediaStream mediaStream) {
        final VideoCapturerInfoEx info = camera.info;
        final VideoSource videoSource = camera.videoSource;
        final String deviceId = camera.deviceId;
        final String facingMode = camera.facingMode;
        final int sensorOrientation = camera.sensorOrientation;

        String trackId = stateProvider.getNextTrackUUID();
        VideoTrack track = peerConnectionFactory().createVideoTrack(trackId, videoSource);
        mediaStream.addTrack(track);

        LocalVideoTrack localVideoTrack = new LocalVideoTrack(track);
        videoSource.setVideoProcessor(localVideoTrack);

        ConstraintsMap trackParams = new ConstraintsMap();

        trackParams.putBoolean("enabled", track.enabled());
        trackParams.putString("id", track.id());
        trackParams.putString("kind", "video");
        trackParams.putString("label", track.id());
        trackParams.putString("readyState", track.state().toString());
        trackParams.putBoolean("remote", false);

        ConstraintsMap settings = new ConstraintsMap();
        settings.putString("deviceId", deviceId);
        settings.putString("kind", "videoinput");
        // Frames are delivered rotated to the display orientation, while the capture format is in
        // sensor space. Report the size of the frames the track actually produces.
        if (shouldSwapDimensions(sensorOrientation, getDisplayRotationDegrees())) {
            settings.putInt("width", info.height);
            settings.putInt("height", info.width);
        } else {
            settings.putInt("width", info.width);
            settings.putInt("height", info.height);
        }
        // Non-standard: tells callers the size above is already in frame orientation.
        if (sensorOrientation >= 0) settings.putInt("sensorOrientation", sensorOrientation);
        // Non-standard: the capture format the camera opened, in sensor space, so the Dart side can
        // log the whole size path (requested -> capture format -> frame size) in one place. Left
        // out when no supported sizes were found, since info then still holds the request.
        final Size captureSize = camera.captureSize;
        if (captureSize != null) {
            settings.putInt("captureWidth", captureSize.width);
            settings.putInt("captureHeight", captureSize.height);
        }
        settings.putInt("frameRate", info.fps);
        if (facingMode != null) settings.putString("facingMode", facingMode);
        trackParams.putMap("settings", settings.toMap());

        // Registered last: a throw above leaves nothing behind for the camera the caller releases.
        // The capturer and source go in before the local track: putLocalTrack attributes the track
        // to its factory through ownsTrack(), which reads these maps. Unattributed, the factory's
        // dispose neither detaches renderers from the track nor releases it, and a renderer that
        // later lets go of the freed track crashes in VideoTrack.removeSink.
        mVideoCapturers.put(trackId, info);
        mSurfaceTextureHelpers.put(trackId, camera.surfaceTextureHelper);
        mVideoSources.put(trackId, videoSource);
        stateProvider.putLocalTrack(track.id(), localVideoTrack);

        return trackParams;
    }

    /**
     * Returns true if this {@code GetUserMediaImpl} owns track-scoped state
     * (capturer, audio source, or recorder) for the given id.
     */
    public boolean ownsTrack(String trackId) {
        if (trackId == null) {
            return false;
        }
        return mVideoCapturers.containsKey(trackId)
                || mAudioSources.containsKey(trackId)
                || mVideoSources.containsKey(trackId);
    }

    /** Returns true if this impl owns the recorder. */
    public boolean ownsRecorder(int recorderId) {
        return mediaRecorders.get(recorderId) != null;
    }

    void removeVideoCapturer(String id) {
        VideoCapturerInfoEx info = mVideoCapturers.get(id);
        if (info != null) {
            try {
                info.capturer.stopCapture();
                if (info.cameraEventsHandler != null) {
                    info.cameraEventsHandler.waitForCameraClosed();
                }
            } catch (InterruptedException e) {
                Log.e(TAG, "removeVideoCapturer() Failed to stop video capturer");
            } finally {
                info.capturer.dispose();
                mVideoCapturers.remove(id);
                SurfaceTextureHelper helper = mSurfaceTextureHelpers.get(id);
                if (helper != null) {
                    helper.stopListening();
                    helper.dispose();
                    mSurfaceTextureHelpers.remove(id);
                    mVideoSources.remove(id);
                }
            }
        }
    }

    void setVideoEffect(String trackId, List<String> names) {
        VideoSource videoSource = mVideoSources.get(trackId);
        SurfaceTextureHelper surfaceTextureHelper = mSurfaceTextureHelpers.get(trackId);

        if (videoSource == null) {
            Log.e(TAG, "setVideoEffect() VideoSource not found for trackId: " + trackId);
            return;
        }

        if (surfaceTextureHelper == null) {
            Log.e(TAG, "setVideoEffect() SurfaceTextureHelper not found for trackId: " + trackId);
            return;
        }

        if (names != null && !names.isEmpty()) {
            List<VideoFrameProcessor> processors = names.stream()
                .filter(name -> name instanceof String)
                .map(name -> {
                    VideoFrameProcessor videoFrameProcessor = ProcessorProvider.getProcessor((String) name);
                    if (videoFrameProcessor == null) {
                        Log.e(TAG, "no videoFrameProcessor associated with this name: " + name);
                    }
                    return videoFrameProcessor;
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

            
            VideoEffectProcessor videoEffectProcessor = new VideoEffectProcessor(processors, surfaceTextureHelper);
            videoSource.setVideoProcessor(videoEffectProcessor);

        } else {
            videoSource.setVideoProcessor(null);
        }
    }

    @RequiresApi(api = VERSION_CODES.M)
    private void requestPermissions(
            final ArrayList<String> permissions,
            final Callback successCallback,
            final Callback errorCallback) {
        PermissionUtils.Callback callback =
                (permissions_, grantResults) -> {
                    List<String> grantedPermissions = new ArrayList<>();
                    List<String> deniedPermissions = new ArrayList<>();

                    for (int i = 0; i < permissions_.length; ++i) {
                        String permission = permissions_[i];
                        int grantResult = grantResults[i];

                        if (grantResult == PackageManager.PERMISSION_GRANTED) {
                            grantedPermissions.add(permission);
                        } else {
                            deniedPermissions.add(permission);
                        }
                    }

                    // Success means that all requested permissions were granted.
                    for (String p : permissions) {
                        if (!grantedPermissions.contains(p)) {
                            // According to step 6 of the getUserMedia() algorithm
                            // "if the result is denied, jump to the step Permission
                            // Failure."
                            errorCallback.invoke(deniedPermissions);
                            return;
                        }
                    }
                    successCallback.invoke(grantedPermissions);
                };

        final Activity activity = stateProvider.getActivity();
        final Context context = stateProvider.getApplicationContext();
        PermissionUtils.requestPermissions(
                context,
                activity,
                permissions.toArray(new String[permissions.size()]), callback);
    }

    void switchCamera(String id, Result result) {
        VideoCapturerInfoEx info = mVideoCapturers.get(id);
        if (info == null || info.capturer == null) {
            resultError("switchCamera", "Video capturer not found for id: " + id, result);
            return;
        }

        VideoCapturer videoCapturer = info.capturer;
        boolean currentIsFrontFacing = info.isFrontFacing;

        CameraEnumerator cameraEnumerator;

        if (Camera2Enumerator.isSupported(applicationContext)) {
            Log.d(TAG, "Creating video capturer using Camera2 API.");
            cameraEnumerator = new Camera2Enumerator(applicationContext);
        } else {
            Log.d(TAG, "Creating video capturer using Camera1 API.");
            cameraEnumerator = new Camera1Enumerator(false);
        }
        // if sourceId given, use specified sourceId first
        final String[] deviceNames = cameraEnumerator.getDeviceNames();
        for (String name : deviceNames) {
            if (cameraEnumerator.isFrontFacing(name) == !currentIsFrontFacing) {
                final String targetCameraName = name;
                final boolean newIsFrontFacing = !currentIsFrontFacing;
                CameraVideoCapturer cameraVideoCapturer = (CameraVideoCapturer) videoCapturer;
                cameraVideoCapturer.switchCamera(
                        new CameraVideoCapturer.CameraSwitchHandler() {
                            @Override
                            public void onCameraSwitchDone(boolean b) {
                                info.isFrontFacing = newIsFrontFacing;
                                info.cameraName = targetCameraName;
                                result.success(info.isFrontFacing);
                            }

                            @Override
                            public void onCameraSwitchError(String s) {
                                resultError("switchCamera", "Switching camera failed: " + id, result);
                            }
                        }, targetCameraName);
                return;
            }
        }
        resultError("switchCamera", "Switching camera failed: " + id, result);
    }

    /**
     * Creates and starts recording of local stream to file
     *
     * @param path         to the file for record
     * @param videoTrack   to record or null if only audio needed
     * @param audioChannel channel for recording or null
     * @throws Exception lot of different exceptions, pass back to dart layer to print them at least
     */
    void startRecordingToFile(
            String path, Integer id, @Nullable VideoTrack videoTrack, @Nullable AudioChannel audioChannel)
            throws Exception {
        AudioSamplesInterceptor interceptor = null;
        if (audioChannel == AudioChannel.INPUT) {
            interceptor = inputSamplesInterceptor;
        } else if (audioChannel == AudioChannel.OUTPUT) {
            if (outputSamplesInterceptor == null) {
                outputSamplesInterceptor = new OutputAudioSamplesInterceptor(audioDeviceModule);
            }
            interceptor = outputSamplesInterceptor;
        }
        MediaRecorderImpl mediaRecorder = new MediaRecorderImpl(id, videoTrack, interceptor);
        mediaRecorder.startRecording(new File(path));
        mediaRecorders.append(id, mediaRecorder);
    }

    void stopRecording(Integer id, String albumName,  Runnable onFinished) {
       MediaRecorderImpl mediaRecorder = mediaRecorders.get(id);
       if (mediaRecorder != null) {
            mediaRecorder.stopRecording(() -> {
                mediaRecorders.remove(id);
                onFinished.run();
            });
        }
    }

    public void reStartCamera(IsCameraEnabled getCameraId) {
        for (Map.Entry<String, VideoCapturerInfoEx> item : mVideoCapturers.entrySet()) {
            if (!item.getValue().isScreenCapture && getCameraId.isEnabled(item.getKey())) {
                item.getValue().capturer.startCapture(
                        item.getValue().width,
                        item.getValue().height,
                        item.getValue().fps
                );
            }
        }
    }

    public interface IsCameraEnabled {
        boolean isEnabled(String id);
    }

    /**
     * True when frames are rotated by 90 or 270 degrees relative to the sensor, so the reported
     * width and height must be swapped. An unknown sensor orientation (-1) never swaps.
     */
    static boolean shouldSwapDimensions(int sensorOrientation, int displayRotationDegrees) {
        if (sensorOrientation < 0) return false;
        return ((sensorOrientation + displayRotationDegrees) % 180) == 90;
    }

    /** The display rotation in degrees (0/90/180/270), as libwebrtc's CameraSession reads it. */
    private int getDisplayRotationDegrees() {
        WindowManager wm =
                (WindowManager) applicationContext.getSystemService(Context.WINDOW_SERVICE);
        if (wm == null) return 0;

        switch (wm.getDefaultDisplay().getRotation()) {
            case Surface.ROTATION_90:
                return 90;
            case Surface.ROTATION_180:
                return 180;
            case Surface.ROTATION_270:
                return 270;
            case Surface.ROTATION_0:
            default:
                return 0;
        }
    }

    public static class VideoCapturerInfoEx extends VideoCapturerInfo {
        public CameraEventsHandler cameraEventsHandler;
        public boolean isFrontFacing;
    }

    public VideoCapturerInfoEx getCapturerInfo(String trackId) {
        return mVideoCapturers.get(trackId);
    }

    @RequiresApi(api = VERSION_CODES.M)
    void setPreferredInputDevice(String deviceId) {
        android.media.AudioManager audioManager = ((android.media.AudioManager) applicationContext.getSystemService(Context.AUDIO_SERVICE));
        final AudioDeviceInfo[] devices = audioManager.getDevices(android.media.AudioManager.GET_DEVICES_INPUTS);
        if (devices.length > 0) {
            for (int i = 0; i < devices.length; i++) {
                AudioDeviceInfo device = devices[i];
                if(deviceId.equals(AudioUtils.getAudioDeviceId(device))) {
                    preferredInput = device;
                    audioDeviceModule.setPreferredInputDevice(preferredInput);
                    return;
                }
            }
        }
    }

    @RequiresApi(api = VERSION_CODES.M)
    int getPreferredInputDevice(AudioDeviceInfo deviceInfo) {
        if (deviceInfo == null) {
            return -1;
        }
        android.media.AudioManager audioManager = ((android.media.AudioManager) applicationContext.getSystemService(Context.AUDIO_SERVICE));
        final AudioDeviceInfo[] devices = audioManager.getDevices(android.media.AudioManager.GET_DEVICES_INPUTS);
        for (int i = 0; i < devices.length; i++) {
            if (devices[i].getId() == deviceInfo.getId()) {
                return i;
            }
        }
        return -1;
    }
}
