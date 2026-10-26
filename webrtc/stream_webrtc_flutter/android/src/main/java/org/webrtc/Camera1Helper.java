/*
 * Copyright 2023-2024 LiveKit, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.webrtc;

import androidx.annotation.Nullable;

import java.util.List;

/**
 * A helper to access package-protected methods used in [Camera2Session]
 * <p>
 * Note: cameraId as used in the Camera1XXX classes refers to the index within the list of cameras.
 *
 * @suppress
 */

public class Camera1Helper {

    public static int getCameraId(String deviceName) {
        return Camera1Enumerator.getCameraIndex(deviceName);
    }

    @Nullable
    public static List<CameraEnumerationAndroid.CaptureFormat> getSupportedFormats(int cameraId) {
        return Camera1Enumerator.getSupportedFormats(cameraId);
    }

    /** The distinct capture sizes of the camera, in sensor space, or an empty list. */
    public static List<Size> getSupportedSizes(int cameraId) {
        return CaptureSizeSelector.distinctSizes(getSupportedFormats(cameraId));
    }

    /**
     * Returns the camera's sensor orientation in degrees (0/90/180/270), or -1 when unknown.
     */
    @SuppressWarnings("deprecation")
    public static int getSensorOrientation(int cameraId) {
        if (cameraId < 0) return -1;
        try {
            android.hardware.Camera.CameraInfo info = new android.hardware.Camera.CameraInfo();
            android.hardware.Camera.getCameraInfo(cameraId, info);
            return info.orientation;
        } catch (Exception e) {
            return -1;
        }
    }
}
