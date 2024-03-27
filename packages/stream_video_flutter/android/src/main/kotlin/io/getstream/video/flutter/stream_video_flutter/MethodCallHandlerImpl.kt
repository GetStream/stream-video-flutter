package io.getstream.video.flutter.stream_video_flutter

import android.Manifest
import android.app.Activity
import android.app.PictureInPictureParams
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFlags
import io.flutter.embedding.android.engine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.getstream.log.taggedLogger
import io.getstream.video.flutter.stream_video_flutter.service.PictureInPictureHelper
import io.getstream.video.flutter.stream_video_flutter.service.ServiceManager
import io.getstream.video.flutter.stream_video_flutter.service.ServiceManagerImpl
import io.getstream.video.flutter.stream_video_flutter.service.ServiceType
import io.getstream.video.flutter.stream_video_flutter.service.StreamCallService
import io.getstream.video.flutter.stream_video_flutter.service.StreamScreenShareService
import io.getstream.video.flutter.stream_video_flutter.service.notification.NotificationPayload
import io.getstream.video.flutter.stream_video_flutter.service.utils.putBoolean

class MethodCallHandlerImpl(
    appContext: Context,
    private val getActivity: () -> Activity?
) : MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private val logger by taggedLogger(tag = "StreamMethodHandler")

    private val serviceManager: ServiceManager = ServiceManagerImpl(appContext.applicationContext)

    private var permissionCallback: ((Result<Unit>) -> Unit)? = null

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        logger.v { "[onRequestPermissionsResult] rc: $requestCode, permissions: $permissions, results: $grantResults" }
        if (requestCode != REQUEST_NOTIFICATIONS) {
            return false
        }
        for (index in permissions.indices) {
            val permission = permissions[index]
            if (permission == Manifest.permission.POST_NOTIFICATIONS) {
                val result = grantResults[index]
                val permissionGranted = result == PackageManager.PERMISSION_GRANTED
                val textResult = if (permissionGranted) "granted" else "denied"
                logger.i { "[onRequestPermissionsResult] POST_NOTIFICATIONS $textResult" }
                if (permissionGranted) {
                    permissionCallback?.invoke(Result.success(Unit))
                } else {
                    permissionCallback?.invoke(Result.failure(PermissionDeniedException()))
                }
                return true
            }
        }
        permissionCallback?.invoke(Result.failure(OnRequestPermissionResultException()))
        return false
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        logger.d { "[onMethodCall] method: ${call.method}" }
        when (call.method) {
            "enablePictureInPictureMode" -> {
                val activity = getActivity()
                putBoolean(activity, PictureInPictureHelper.PIP_ENABLED_PREF_KEY, true)
            }
            "disablePictureInPictureMode" -> {
                val activity = getActivity()
                putBoolean(activity, PictureInPictureHelper.PIP_ENABLED_PREF_KEY, false)
                PictureInPictureHelper.disablePictureInPicture(activity!!)
            }
            "isBackgroundServiceRunning" -> {
                val statusString = call.argument<String>("type")
                val serviceType = ServiceType.valueOf(statusString ?: "call")

                val isRunning = when(serviceType){
                    ServiceType.call -> StreamCallService.isRunning
                    ServiceType.screenSharing -> StreamScreenShareService.isRunning
                }

                logger.d { "[onMethodCall] #isServiceRunning($serviceType); isRunning: $isRunning" }
                result.success(isRunning)
            }

            "startBackgroundService" -> {
                val statusString = call.argument<String>("type")
                val serviceType = ServiceType.valueOf(statusString ?: "call")

                val activity = getActivity()
                if (activity == null) {
                    logger.e { "[onMethodCall] #startService($serviceType); failed (No activity found)" }
                    result.error("startService", "No activity found", null)
                    return
                }
                val engine = activity.engine
                if (engine == null) {
                    logger.e { "[onMethodCall] #startService($serviceType); failed (No engine found)" }
                    result.error("startService", "Host activity has no FlutterEngine", activity::class.qualifiedName)
                    return
                }
                try {
                    activity.requestPermission {
                        val error = it.exceptionOrNull()
                        if (error != null) {
                            logger.e { "[onMethodCall] #startService($serviceType); permission failed: $error" }
                            result.error("startService", error.toString(), null)
                            return@requestPermission
                        }

                        val notificationPayload = call.extractNotificationPayload()
                        logger.d { "[onMethodCall] #startService($serviceType); notificationPayload: $notificationPayload" }
                        FlutterEngineCache.getInstance().put(STREAM_FLUTTER_BACKGROUND_ENGINE_ID, engine)
                        activity.intent?.putExtra(FlutterFlags.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY, false)

                        result.success(serviceManager.start(notificationPayload, serviceType))
                    }
                } catch (e: Throwable) {
                    logger.e { "[onMethodCall] #startService($serviceType);  failed: $e" }
                    result.error("startService", e.toString(), null)
                }
            }

            "updateBackgroundService" -> {
                val statusString = call.argument<String>("type")
                val serviceType = ServiceType.valueOf(statusString ?: "call")

                try {
                    val notificationPayload = call.extractNotificationPayload()
                    logger.d { "[onMethodCall] #updateService($serviceType); notificationPayload: $notificationPayload" }
                    result.success(serviceManager.update(notificationPayload, serviceType))
                } catch (e: Throwable) {
                    logger.e { "[onMethodCall] #updateService($serviceType); failed: $e" }
                    result.error("updateService", e.toString(), null)
                }
            }

            "stopBackgroundService" -> {
                val statusString = call.argument<String>("type")
                val serviceType = ServiceType.valueOf(statusString ?: "call")

                val activity = getActivity()
                try {
                    FlutterEngineCache.getInstance().remove(STREAM_FLUTTER_BACKGROUND_ENGINE_ID)
                    activity?.intent?.removeExtra(FlutterFlags.EXTRA_DESTROY_ENGINE_WITH_ACTIVITY)

                    result.success(serviceManager.stop(serviceType))
                } catch (e: Throwable) {
                    logger.e { "[onMethodCall] #stopService($serviceType); failed: $e" }
                    result.error("stopService", e.toString(), null)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun MethodCall.extractNotificationPayload(): NotificationPayload {
        return  NotificationPayload.fromJson(arguments)
    }

    private fun Activity.requestPermission(callback: (Result<Unit>) -> Unit) {
        logger.d { "[requestPermission] no args" }
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            callback(Result.success(Unit))
            return
        }
        when {
            ContextCompat.checkSelfPermission(
                this, Manifest.permission.POST_NOTIFICATIONS
            ) == PackageManager.PERMISSION_GRANTED -> {
                logger.v { "[requestPermission] already granted" }
                callback(Result.success(Unit))
            }

            ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.POST_NOTIFICATIONS) -> {
                logger.i { "[requestPermission] rationale requested" }
                callback(Result.failure(PermissionRationaleRequiredException()))
            }

            else -> {
                logger.i { "[requestPermission] resultCode: $REQUEST_NOTIFICATIONS" }
                if (permissionCallback != null) {
                    logger.e { "[onMethodCall] #startService; failed (No engine found)" }
                    callback(Result.failure(PermissionRequestAlreadyRunningException()))
                    return
                }
                permissionCallback = callback
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    REQUEST_NOTIFICATIONS,
                )
            }
        }
    }

    private companion object {
        private const val REQUEST_NOTIFICATIONS = 72
    }

}

private sealed class NotificationPermissionException(message: String) : Exception(message)
private class OnRequestPermissionResultException : NotificationPermissionException(
    message = "'permissions' parameter does not contain POST_NOTIFICATIONS"
) {
    override fun toString(): String = "OnRequestPermissionResultException(message=$message)"
}

private class PermissionRequestAlreadyRunningException : NotificationPermissionException(
    message = "A request for POST_NOTIFICATIONS permission is already running"
) {
    override fun toString(): String = "PermissionRequestAlreadyRunningException(message=$message)"
}

private class PermissionDeniedException : NotificationPermissionException(
    message = "Permission POST_NOTIFICATIONS has been denied"
) {
    override fun toString(): String = "PermissionDeniedException(message=$message)"
}

private class PermissionRationaleRequiredException : NotificationPermissionException(
    message = "Permission rationale is required for POST_NOTIFICATIONS permission"
) {
    override fun toString(): String = "PermissionRationaleRequiredException(message=$message)"
}