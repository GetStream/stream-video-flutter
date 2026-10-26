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

import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;

import androidx.annotation.Nullable;

import java.util.List;

/**
 * A helper to access package-protected methods used in [Camera2Session]
 * <p>
 * Note: cameraId as used in the Camera2XXX classes refers to the id returned
 * by [CameraManager.getCameraIdList].
 */
public class Camera2Helper {

    @Nullable
    public static List<CameraEnumerationAndroid.CaptureFormat> getSupportedFormats(CameraManager cameraManager, @Nullable String cameraId) {
        return Camera2Enumerator.getSupportedFormats(cameraManager, cameraId);
    }

    /** The distinct capture sizes of the camera, in sensor space, or an empty list. */
    public static List<Size> getSupportedSizes(CameraManager cameraManager, @Nullable String cameraId) {
        return CaptureSizeSelector.distinctSizes(getSupportedFormats(cameraManager, cameraId));
    }

    /**
     * Returns the camera's sensor orientation in degrees (0/90/180/270), or -1 when unknown.
     */
    public static int getSensorOrientation(CameraManager cameraManager, @Nullable String cameraId) {
        if (cameraId == null) return -1;
        try {
            Integer orientation = cameraManager
                    .getCameraCharacteristics(cameraId)
                    .get(CameraCharacteristics.SENSOR_ORIENTATION);
            return orientation == null ? -1 : orientation;
        } catch (Exception e) {
            return -1;
        }
    }
}
