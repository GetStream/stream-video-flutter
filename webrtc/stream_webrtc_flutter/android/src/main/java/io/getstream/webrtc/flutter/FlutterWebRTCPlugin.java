package io.getstream.webrtc.flutter;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import io.getstream.webrtc.flutter.audio.AudioProcessingFactoryProvider;
import io.getstream.webrtc.flutter.audio.AudioProcessingController;
import io.getstream.webrtc.flutter.audio.AudioSwitchManager;
import io.getstream.webrtc.flutter.utils.AnyThreadSink;
import io.getstream.webrtc.flutter.utils.ConstraintsMap;

import com.twilio.audioswitch.AudioDevice;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import org.webrtc.ExternalAudioProcessingFactory;
import org.webrtc.MediaStreamTrack;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.TextureRegistry;

/**
 * FlutterWebRTCPlugin
 */
public class FlutterWebRTCPlugin implements FlutterPlugin, ActivityAware, EventChannel.StreamHandler {

    static public final String TAG = "FlutterWebRTCPlugin";
    private static Application application;

    private MethodChannel methodChannel;
    private MethodCallHandlerImpl methodCallHandler;
    private LifeCycleObserver observer;
    private Lifecycle lifecycle;
    private EventChannel eventChannel;

    /** The audio devices last reported with an onDeviceChange event. */
    @Nullable
    private List<AudioDevice> lastReportedAudioDevices;

    // The sinks of every engine listening on FlutterWebRTC.Event. An app can run more
    // than one engine (e.g. a background engine for push messages), each with its own
    // plugin instance, and every one of them receives every event.
    private static final List<EventChannel.EventSink> eventSinks = new CopyOnWriteArrayList<>();

    /** This engine's sink, while its Dart side listens. */
    @Nullable
    private EventChannel.EventSink eventSink;

    public FlutterWebRTCPlugin() {
        if (sharedSingleton == null) {
            sharedSingleton = this;
        } else {
            Log.w(TAG, "Warning - Multiple plugin instances detected. Keeping existing singleton.");
        }
    }

    public static FlutterWebRTCPlugin sharedSingleton;

    public void setAudioProcessingFactoryProvider(AudioProcessingFactoryProvider provider) {
        methodCallHandler.audioProcessingFactoryProvider = provider;
    }

    public AudioProcessingFactoryProvider getAudioProcessingFactoryProvider() {
        return methodCallHandler.audioProcessingFactoryProvider;
    }

    public MediaStreamTrack getTrackForId(String trackId, String peerConnectionId) {
        return methodCallHandler.getTrackForId(trackId, peerConnectionId);
    }

    public LocalTrack getLocalTrack(String trackId) {
        return methodCallHandler.getLocalTrack(trackId);
    }

    public MediaStreamTrack getRemoteTrack(String trackId) {
        return methodCallHandler.getRemoteTrack(trackId);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        startListening(binding.getApplicationContext(), binding.getBinaryMessenger(),
                binding.getTextureRegistry());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        stopListening();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        methodCallHandler.setActivity(binding.getActivity());
        // Also set Activity on AudioSwitchManager for setVolumeControlStream support
        if (AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setActivity(binding.getActivity());
        }
        this.observer = new LifeCycleObserver();
        this.lifecycle = ((HiddenLifecycleReference) binding.getLifecycle()).getLifecycle();
        this.lifecycle.addObserver(this.observer);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        methodCallHandler.setActivity(null);
        if (AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setActivity(null);
        }
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        methodCallHandler.setActivity(binding.getActivity());
        if (AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setActivity(binding.getActivity());
        }
    }

    @Override
    public void onDetachedFromActivity() {
        methodCallHandler.setActivity(null);
        if (AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setActivity(null);
        }
        if (this.observer != null) {
            this.lifecycle.removeObserver(this.observer);
            if (application!=null) {
                application.unregisterActivityLifecycleCallbacks(this.observer);
            }
        }
        this.lifecycle = null;
    }

    private void startListening(final Context context, BinaryMessenger messenger,
                                TextureRegistry textureRegistry) {
        if (AudioSwitchManager.instance == null) {
            AudioSwitchManager.instance = new AudioSwitchManager(context);
        }

        methodCallHandler = new MethodCallHandlerImpl(context, messenger, textureRegistry);
        methodChannel = new MethodChannel(messenger, "FlutterWebRTC.Method");
        methodChannel.setMethodCallHandler(methodCallHandler);
        eventChannel = new EventChannel( messenger,"FlutterWebRTC.Event");
        eventChannel.setStreamHandler(this);
        lastReportedAudioDevices = null;
        AudioSwitchManager.instance.audioDeviceChangeListener = (devices, currentDevice) -> {
            Log.w(TAG, "audioFocusChangeListener " + devices+ " " + currentDevice);
            // AudioSwitch also calls this when only the selected device changes,
            // and on every selection when it doesn't handle audio routing. Dart
            // re-enumerates all devices on each event, so only report changes
            // to the device list.
            if (devices.equals(lastReportedAudioDevices)) {
                return null;
            }
            lastReportedAudioDevices = new ArrayList<>(devices);

            ConstraintsMap params = new ConstraintsMap();
            params.putString("event", "onDeviceChange");
            sendEvent(params.toMap());
            return null;
        };
    }

    private void stopListening() {
        methodCallHandler.dispose();
        methodCallHandler = null;
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        removeEventSink();
        if (AudioSwitchManager.instance != null) {
            Log.d(TAG, "Stopping the audio manager...");
            AudioSwitchManager.instance.stop();
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        removeEventSink();
        eventSink = new AnyThreadSink(events);
        eventSinks.add(eventSink);
    }

    @Override
    public void onCancel(Object arguments) {
        removeEventSink();
    }

    private void removeEventSink() {
        if (eventSink != null) {
            eventSinks.remove(eventSink);
            eventSink = null;
        }
    }

    /** Sends the event to every engine listening on FlutterWebRTC.Event. */
    public void sendEvent(Object event) {
        for (EventChannel.EventSink sink : eventSinks) {
            sink.success(event);
        }
    }

    private class LifeCycleObserver implements Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver {

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

        }

        @Override
        public void onActivityStarted(Activity activity) {

        }

        @Override
        public void onActivityResumed(Activity activity) {
            if (null != methodCallHandler) {
                methodCallHandler.reStartCamera();
            }
        }

        @Override
        public void onResume(LifecycleOwner owner) {
            if (null != methodCallHandler) {
                methodCallHandler.reStartCamera();
            }
        }

        @Override
        public void onActivityPaused(Activity activity) {

        }

        @Override
        public void onActivityStopped(Activity activity) {

        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

        }

        @Override
        public void onActivityDestroyed(Activity activity) {

        }
    }
}
