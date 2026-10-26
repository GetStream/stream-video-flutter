package io.getstream.webrtc.flutter;

import android.util.Log;
import android.graphics.SurfaceTexture;
import android.view.Surface;

import io.getstream.webrtc.flutter.utils.AnyThreadSink;
import io.getstream.webrtc.flutter.utils.ConstraintsMap;
import io.getstream.webrtc.flutter.utils.EglUtils;

import java.util.List;

import org.webrtc.EglBase;
import org.webrtc.MediaStream;
import org.webrtc.RendererCommon.RendererEvents;
import org.webrtc.VideoTrack;

import io.flutter.plugin.common.EventChannel;
import io.flutter.view.TextureRegistry;

public class FlutterRTCVideoRenderer implements EventChannel.StreamHandler {

    private static final String TAG = FlutterWebRTCPlugin.TAG;
    private final TextureRegistry.SurfaceProducer producer;
    private int id = -1;
    private MediaStream mediaStream;

    private String ownerTag;

    public void Dispose() {
        //destroy
        if (surfaceTextureRenderer != null) {
            surfaceTextureRenderer.release();
        }
        if (eventChannel != null)
            eventChannel.setStreamHandler(null);

        eventSink = null;
        producer.release();
    }

    /**
     * The {@code RendererEvents} which listens to rendering events reported by
     * {@link #surfaceTextureRenderer}.
     */
    private RendererEvents rendererEvents;

    private void listenRendererEvents() {
        rendererEvents = new RendererEvents() {
            private int _rotation = -1;
            private int _width = 0, _height = 0;

            // These callbacks run on WebRTC's video thread while onCancel clears
            // eventSink on the main thread, so read the field once into a local.
            // An exception escaping here propagates into JNI and aborts the process.
            @Override
            public void onFirstFrameRendered() {
                final EventChannel.EventSink sink = eventSink;
                if (sink == null) {
                    return;
                }
                try {
                    ConstraintsMap params = new ConstraintsMap();
                    params.putString("event", "didFirstFrameRendered");
                    params.putInt("id", id);
                    sink.success(params.toMap());
                } catch (Exception e) {
                    Log.e(TAG, "onFirstFrameRendered failed", e);
                }
            }

            @Override
            public void onFrameResolutionChanged(
                    int videoWidth, int videoHeight,
                    int rotation) {
                final EventChannel.EventSink sink = eventSink;
                if (sink == null) {
                    return;
                }
                try {
                    if (_width != videoWidth || _height != videoHeight) {
                        ConstraintsMap params = new ConstraintsMap();
                        params.putString("event", "didTextureChangeVideoSize");
                        params.putInt("id", id);
                        params.putDouble("width", (double) videoWidth);
                        params.putDouble("height", (double) videoHeight);
                        _width = videoWidth;
                        _height = videoHeight;
                        sink.success(params.toMap());
                    }

                    if (_rotation != rotation) {
                        ConstraintsMap params2 = new ConstraintsMap();
                        params2.putString("event", "didTextureChangeRotation");
                        params2.putInt("id", id);
                        params2.putInt("rotation", rotation);
                        _rotation = rotation;
                        sink.success(params2.toMap());
                    }
                } catch (Exception e) {
                    Log.e(TAG, "onFrameResolutionChanged failed", e);
                }
            }
        };
    }

    private final SurfaceTextureRenderer surfaceTextureRenderer;

    /**
     * The {@code VideoTrack}, if any, rendered by this {@code FlutterRTCVideoRenderer}.
     */
    private VideoTrack videoTrack;

    EventChannel eventChannel;
    volatile EventChannel.EventSink eventSink;

    public FlutterRTCVideoRenderer(TextureRegistry.SurfaceProducer producer) {
        this.surfaceTextureRenderer = new SurfaceTextureRenderer("");
        listenRendererEvents();
        surfaceTextureRenderer.init(EglUtils.getRootEglBaseContext(), rendererEvents);
        surfaceTextureRenderer.surfaceCreated(producer);

        this.eventSink = null;
        this.producer = producer;
        this.ownerTag = null;
    }

    public void setEventChannel(EventChannel eventChannel) {
        this.eventChannel = eventChannel;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink sink) {
        eventSink = new AnyThreadSink(sink);
    }

    @Override
    public void onCancel(Object o) {
        eventSink = null;
    }

    /**
     * Stops rendering {@link #videoTrack} and releases the associated acquired
     * resources (if rendering is in progress).
     */
    private void removeRendererFromVideoTrack() {
        try {
            videoTrack.removeSink(surfaceTextureRenderer);
        } catch (Throwable t) {
            Log.w(TAG, "removeRendererFromVideoTrack: track stale: " + t);
        }
    }

    public void forceClearVideoTrack() {
        this.videoTrack = null;
        this.mediaStream = null;
    }

    public boolean detachIfRenderingAny(java.util.Set<String> dyingTrackIds) {
        final VideoTrack current = this.videoTrack;
        if (current == null || dyingTrackIds == null || dyingTrackIds.isEmpty()) {
            return false;
        }

        String currentId;
        try {
            currentId = current.id();
        } catch (Throwable t) {
            // Native peer already gone — drop the reference defensively.
            forceClearVideoTrack();
            return true;
        }
        if (currentId != null && dyingTrackIds.contains(currentId)) {
            forceClearVideoTrack();
            return true;
        }
        
        return false;
    }

    /**
     * Sets the {@code MediaStream} to be rendered by this {@code FlutterRTCVideoRenderer}.
     * The implementation renders the first {@link VideoTrack}, if any, of the
     * specified {@code mediaStream}.
     *
     * @param mediaStream The {@code MediaStream} to be rendered by this
     *                    {@code FlutterRTCVideoRenderer} or {@code null}.
     */
    public void setStream(MediaStream mediaStream, String ownerTag) {
        VideoTrack videoTrack;
        this.mediaStream = mediaStream;
        this.ownerTag = ownerTag;
        if (mediaStream == null) {
            videoTrack = null;
        } else {
            List<VideoTrack> videoTracks = mediaStream.videoTracks;

            videoTrack = videoTracks.isEmpty() ? null : videoTracks.get(0);
        }

        setVideoTrack(videoTrack);
    }
   /**
     * Sets the {@code MediaStream} to be rendered by this {@code FlutterRTCVideoRenderer}.
     * The implementation renders the first {@link VideoTrack}, if any, of the
     * specified trackId
     *
     * @param mediaStream The {@code MediaStream} to be rendered by this
     *                    {@code FlutterRTCVideoRenderer} or {@code null}.
     * @param trackId The {@code trackId} to be rendered by this
     *                    {@code FlutterRTCVideoRenderer} or {@code null}.
     */
    public void setStream(MediaStream mediaStream,String trackId, String ownerTag) {
        VideoTrack videoTrack;
        this.mediaStream = mediaStream;
        this.ownerTag = ownerTag;
        if (mediaStream == null) {
            videoTrack = null;
        } else {
            List<VideoTrack> videoTracks = mediaStream.videoTracks;

            videoTrack = videoTracks.isEmpty() ? null : videoTracks.get(0);

            for (VideoTrack track : videoTracks){
                if (track.id().equals(trackId)){
                    videoTrack = track;
                }
            }
        }

        setVideoTrack(videoTrack);
    }

    /**
     * Sets the {@code VideoTrack} to be rendered by this {@code FlutterRTCVideoRenderer}.
     *
     * @param videoTrack The {@code VideoTrack} to be rendered by this
     *                   {@code FlutterRTCVideoRenderer} or {@code null}.
     */
    public void setVideoTrack(VideoTrack videoTrack) {
        VideoTrack oldValue = this.videoTrack;

        if (oldValue != videoTrack) {
            if (oldValue != null) {
                removeRendererFromVideoTrack();
            }

            this.videoTrack = videoTrack;

            if (videoTrack != null) {
                try {
                    Log.w(TAG, "FlutterRTCVideoRenderer.setVideoTrack, set video track to " + videoTrack.id());
                    tryAddRendererToVideoTrack();
                } catch (Exception e) {
                    Log.e(TAG, "tryAddRendererToVideoTrack " + e);
                }
            } else {
                Log.w(TAG, "FlutterRTCVideoRenderer.setVideoTrack, set video track to null");
            }
        }
    }

    /**
     * Starts rendering {@link #videoTrack} if rendering is not in progress and
     * all preconditions for the start of rendering are met.
     */
    private void tryAddRendererToVideoTrack() throws Exception {
        if (videoTrack != null) {
            EglBase.Context sharedContext = EglUtils.getRootEglBaseContext();

            if (sharedContext == null) {
                // If SurfaceViewRenderer#init() is invoked, it will throw a
                // RuntimeException which will very likely kill the application.
                Log.e(TAG, "Failed to render a VideoTrack!");
                return;
            }

            surfaceTextureRenderer.release();
            listenRendererEvents();
            surfaceTextureRenderer.init(sharedContext, rendererEvents);
            surfaceTextureRenderer.surfaceCreated(producer);

            videoTrack.addSink(surfaceTextureRenderer);
        }
    }

    public boolean checkMediaStream(String id, String ownerTag) {
        if (null == id || null == mediaStream || ownerTag == null || !ownerTag.equals(this.ownerTag)) {
            return false;
        }
        return id.equals(mediaStream.getId());
    }

    public boolean checkVideoTrack(String id, String ownerTag) {
        if (null == id || null == videoTrack  || ownerTag == null || !ownerTag.equals(this.ownerTag)) {
            return false;
        }
        return id.equals(videoTrack.id());
    }
}
