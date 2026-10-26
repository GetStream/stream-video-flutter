package io.getstream.webrtc.flutter;

import android.util.Log;

import org.webrtc.CameraVideoCapturer;

class CameraEventsHandler implements CameraVideoCapturer.CameraEventsHandler {
    public enum CameraState {
        NEW,
        OPENING,
        OPENED,
        CLOSED,
        DISCONNECTED,
        ERROR,
        FREEZED
    }
    private final static String TAG = FlutterWebRTCPlugin.TAG;
    private final Object lock = new Object();
    private CameraState state = CameraState.NEW;

    private static final long TIMEOUT_MS = 2000L;

    public void waitForCameraOpen() {
        Log.d(TAG, "CameraEventsHandler.waitForCameraOpen");
        synchronized (lock) {
            long deadlineMs = System.currentTimeMillis() + TIMEOUT_MS;
            while (state != CameraState.OPENED && state != CameraState.ERROR) {
                long remaining = deadlineMs - System.currentTimeMillis();
                if (remaining <= 0) {
                    Log.w(TAG, "CameraEventsHandler.waitForCameraOpen timed out in state " + state);
                    return;
                }
                try {
                    lock.wait(remaining);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
    }

    public void waitForCameraClosed() {
        Log.d(TAG, "CameraEventsHandler.waitForCameraClosed");
        synchronized (lock) {
            long deadlineMs = System.currentTimeMillis() + TIMEOUT_MS;
            while (state != CameraState.CLOSED
                    && state != CameraState.ERROR
                    && state != CameraState.DISCONNECTED) {
                long remaining = deadlineMs - System.currentTimeMillis();
                if (remaining <= 0) {
                    Log.w(TAG, "CameraEventsHandler.waitForCameraClosed timed out in state " + state);
                    return;
                }
                try {
                    lock.wait(remaining);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
    }

    private void setState(CameraState newState) {
        synchronized (lock) {
            state = newState;
            lock.notifyAll();
        }
    }

    @Override
    public void onCameraError(String errorDescription) {
        Log.d(TAG, String.format("CameraEventsHandler.onCameraError: errorDescription=%s", errorDescription));
        setState(CameraState.ERROR);
    }

    @Override
    public void onCameraDisconnected() {
        Log.d(TAG, "CameraEventsHandler.onCameraDisconnected");
        setState(CameraState.DISCONNECTED);
    }

    @Override
    public void onCameraFreezed(String errorDescription) {
        Log.d(TAG, String.format("CameraEventsHandler.onCameraFreezed: errorDescription=%s", errorDescription));
        setState(CameraState.FREEZED);
    }

    @Override
    public void onCameraOpening(String cameraName) {
        Log.d(TAG, String.format("CameraEventsHandler.onCameraOpening: cameraName=%s", cameraName));
        setState(CameraState.OPENING);
    }

    @Override
    public void onFirstFrameAvailable() {
        Log.d(TAG, "CameraEventsHandler.onFirstFrameAvailable");
        setState(CameraState.OPENED);
    }

    @Override
    public void onCameraClosed() {
        Log.d(TAG, "CameraEventsHandler.onCameraClosed");
        setState(CameraState.CLOSED);
    }
}
