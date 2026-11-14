package io.getstream.video.flutter.stream_video_push_notification

import android.app.Activity
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ActivityInfo
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.Window
import android.view.WindowManager
import android.view.animation.AnimationUtils
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import io.getstream.video.flutter.stream_video_push_notification.widgets.RippleRelativeLayout
import de.hdodenhof.circleimageview.CircleImageView
import kotlin.math.abs
import android.view.ViewGroup.MarginLayoutParams
import android.os.PowerManager
import android.text.TextUtils
import android.util.Log
import androidx.core.content.ContextCompat
import io.getstream.video.flutter.stream_video_push_notification.core.CallPayloadMapper
import io.getstream.video.flutter.stream_video_push_notification.core.RingingComponents
import io.getstream.video.flutter.stream_video_push_notification.notification.AvatarLoader
import io.getstream.video.flutter.stream_video_push_notification.notification.IncomingCallNotificationBuilder

class IncomingCallActivity : Activity() {

    companion object {

        private const val TAG = "IncomingCallActivity"

        private const val ACTION_ENDED_CALL_INCOMING =
            "io.getstream.video.ACTION_ENDED_CALL_INCOMING"

        fun getIntent(context: Context, data: Bundle) =
            Intent(IncomingCallConstants.ACTION_CALL_INCOMING).apply {
                action = "${context.packageName}.${IncomingCallConstants.ACTION_CALL_INCOMING}"
                putExtra(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA, data)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }

        fun getIntentEnded(context: Context, isAccepted: Boolean): Intent {
            val intent = Intent("${context.packageName}.${ACTION_ENDED_CALL_INCOMING}")
            intent.putExtra("ACCEPTED", isAccepted)
            return intent
        }
    }

    inner class EndedIncomingCallBroadcastReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (!isFinishing) {
                val isAccepted = intent.getBooleanExtra("ACCEPTED", false)
                if (isAccepted) {
                    finishDelayed()
                } else {
                    finishTask()
                }
            }
        }
    }

    private var endedIncomingCallBroadcastReceiver = EndedIncomingCallBroadcastReceiver()
    private var isEndedReceiverRegistered = false

    private lateinit var ivBackground: ImageView
    private lateinit var llBackgroundAnimation: RippleRelativeLayout

    private lateinit var tvCallerName: TextView
    private lateinit var tvNumber: TextView
    private lateinit var ivLogo: ImageView
    private lateinit var ivAvatar: CircleImageView

    private lateinit var llAction: LinearLayout
    private lateinit var ivAcceptCall: ImageView
    private lateinit var tvAccept: TextView

    private lateinit var ivDeclineCall: ImageView
    private lateinit var tvDecline: TextView

    private var wakeLock: PowerManager.WakeLock? = null

    @Suppress("DEPRECATION")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val data = intent.extras?.getBundle(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
        if (data == null) {
            finish()
            return
        }
        requestedOrientation = if (!Utils.isTablet(this@IncomingCallActivity)) {
            ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        } else {
            ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            setTurnScreenOn(true)
            setShowWhenLocked(true)
        } else {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
            window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
            window.addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD)
        }
        transparentStatusAndNavigation()
        setContentView(R.layout.activity_incoming_call)
        initView()
        incomingData(data)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(
                endedIncomingCallBroadcastReceiver,
                IntentFilter("${packageName}.${ACTION_ENDED_CALL_INCOMING}"),
                Context.RECEIVER_EXPORTED,
            )
        } else {
            registerReceiver(
                endedIncomingCallBroadcastReceiver,
                IntentFilter("${packageName}.${ACTION_ENDED_CALL_INCOMING}")
            )
        }
        isEndedReceiverRegistered = true
    }

    private fun wakeLockRequest(duration: Long) {
        val pm = applicationContext.getSystemService(POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(
            PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "IncomingCall:PowerManager"
        )
        wakeLock?.acquire(duration)
    }

    private fun transparentStatusAndNavigation() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT && Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            setWindowFlag(
                WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS
                        or WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION, true
            )
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            setWindowFlag(
                (WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS
                        or WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION), false
            )
            window.statusBarColor = Color.TRANSPARENT
            window.navigationBarColor = Color.TRANSPARENT
        }
    }

    private fun setWindowFlag(bits: Int, on: Boolean) {
        val win: Window = window
        val winParams: WindowManager.LayoutParams = win.attributes
        if (on) {
            winParams.flags = winParams.flags or bits
        } else {
            winParams.flags = winParams.flags and bits.inv()
        }
        win.attributes = winParams
    }


    /** [color] as an ARGB int, or null when it is absent or malformed. */
    private fun parseColorOrNull(color: String?): Int? {
        if (color.isNullOrEmpty()) return null
        return try {
            Color.parseColor(color)
        } catch (error: IllegalArgumentException) {
            Log.w(TAG, "Ignoring unparseable colour \"$color\"", error)
            null
        }
    }

    private fun incomingData(data: Bundle) {
        val showFullScreenOnLockScreen =
            data.getBoolean(IncomingCallConstants.EXTRA_CALL_IS_SHOW_FULL_LOCKED_SCREEN, true)
        if (showFullScreenOnLockScreen) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                setShowWhenLocked(true)
            } else {
                window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
            }
        }

        // No default: without a colour from the integrator every label keeps
        // the one the layout gives it, and the design does not paint the
        // caller's name, the handle and the action labels the same.
        val textColor = parseColorOrNull(
            data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_TEXT_COLOR)
        )
        val showCallHandle = data.getBoolean(IncomingCallConstants.EXTRA_CALL_SHOW_CALL_HANDLE, false)
        tvCallerName.text = data.getString(IncomingCallConstants.EXTRA_CALL_NAME_CALLER, "")
        tvNumber.text = data.getString(IncomingCallConstants.EXTRA_CALL_HANDLE, "")
        tvNumber.visibility = if (showCallHandle) View.VISIBLE else View.INVISIBLE

        if (textColor != null) {
            tvCallerName.setTextColor(textColor)
            tvNumber.setTextColor(textColor)
        }

        val showLogo = data.getBoolean(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_SHOW_LOGO, false)
        ivLogo.visibility = if (showLogo) View.VISIBLE else View.INVISIBLE
        val headers = AvatarLoader.headers(data)
        AvatarLoader.resolve(
            data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_LOGO_URL, ""),
        )?.let { AvatarLoader.loadInto(ivLogo, it, headers, R.drawable.transparent) }

        AvatarLoader.avatarUrl(
            data.getString(IncomingCallConstants.EXTRA_CALL_AVATAR, ""),
            data.getString(IncomingCallConstants.EXTRA_CALL_DEFAULT_AVATAR, ""),
        )?.let {
            ivAvatar.visibility = View.VISIBLE
            AvatarLoader.loadInto(ivAvatar, it, headers, R.drawable.ic_default_avatar)
        }

        val callType = data.getInt(IncomingCallConstants.EXTRA_CALL_TYPE, 0)
        if (callType > 0) {
            ivAcceptCall.setImageResource(R.drawable.ic_video)
        }
        val duration = data.getLong(IncomingCallConstants.EXTRA_CALL_DURATION, 0L)
        wakeLockRequest(duration)

        finishTimeout(data, duration)

        val textAccept = data.getString(IncomingCallConstants.EXTRA_CALL_TEXT_ACCEPT, "")
        tvAccept.text =
            if (TextUtils.isEmpty(textAccept)) getString(R.string.text_accept) else textAccept
        val textDecline = data.getString(IncomingCallConstants.EXTRA_CALL_TEXT_DECLINE, "")
        tvDecline.text =
            if (TextUtils.isEmpty(textDecline)) getString(R.string.text_decline) else textDecline

        if (textColor != null) {
            tvAccept.setTextColor(textColor)
            tvDecline.setTextColor(textColor)
        }

        val backgroundColor = parseColorOrNull(
            data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_COLOR)
        ) ?: ContextCompat.getColor(this, R.color.incoming_call_background)
        ivBackground.setBackgroundColor(backgroundColor)
        AvatarLoader.resolve(
            data.getString(IncomingCallConstants.EXTRA_CALL_FULL_SCREEN_BACKGROUND_URL, ""),
        )?.let { AvatarLoader.loadInto(ivBackground, it, headers, R.drawable.transparent) }
    }

    private fun finishTimeout(data: Bundle?, duration: Long) {
        val currentSystemTime = System.currentTimeMillis()
        val timeStartCall =
            data?.getLong(IncomingCallNotificationBuilder.EXTRA_TIME_START_CALL, currentSystemTime)
                ?: currentSystemTime

        val timeOut = duration - abs(currentSystemTime - timeStartCall)
        Handler(Looper.getMainLooper()).postDelayed({
            if (!isFinishing) {
                finishTask()
            }
        }, timeOut)
    }

    private fun initView() {
        ivBackground = findViewById(R.id.ivBackground)
        llBackgroundAnimation = findViewById(R.id.llBackgroundAnimation)
        llBackgroundAnimation.layoutParams.height =
            Utils.getScreenWidth() + Utils.getStatusBarHeight(this@IncomingCallActivity)
        llBackgroundAnimation.startRippleAnimation()

        tvCallerName = findViewById(R.id.tvCallerName)
        tvNumber = findViewById(R.id.tvNumber)
        ivLogo = findViewById(R.id.ivLogo)
        ivAvatar = findViewById(R.id.ivAvatar)

        llAction = findViewById(R.id.llAction)

        val params = llAction.layoutParams as MarginLayoutParams
        params.setMargins(0, 0, 0, Utils.getNavigationBarHeight(this@IncomingCallActivity))
        llAction.layoutParams = params

        ivAcceptCall = findViewById(R.id.ivAcceptCall)
        tvAccept = findViewById(R.id.tvAccept)
        ivDeclineCall = findViewById(R.id.ivDeclineCall)
        tvDecline = findViewById(R.id.tvDecline)
        animateAcceptCall()

        ivAcceptCall.setOnClickListener {
            onAcceptClick()
        }
        ivDeclineCall.setOnClickListener {
            onDeclineClick()
        }
    }

    private fun animateAcceptCall() {
        val shakeAnimation =
            AnimationUtils.loadAnimation(this@IncomingCallActivity, R.anim.shake_anim)
        ivAcceptCall.animation = shakeAnimation
    }

    private fun onAcceptClick() {
        val data = intent.extras?.getBundle(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)

        // The ring and its timeout stop here. On the lock screen the trampoline, which runs the
        // accept and brings the app forward, may only start once the keyguard is dismissed.
        if (data != null) {
            val components = RingingComponents.get(this)
            components.ringTimer.cancel(CallPayloadMapper.fromBundle(data).id)
            components.notifications.clearIncomingNotification(data, true)
        }
        val acceptIntent =
            TransparentActivity.getIntent(this, IncomingCallConstants.ACTION_CALL_ACCEPT, data)
        startActivity(acceptIntent)

        dismissKeyguard()
        finish()
    }

    private fun dismissKeyguard() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        }
    }

    private fun onDeclineClick() {
        val data = intent.extras?.getBundle(IncomingCallConstants.EXTRA_CALL_INCOMING_DATA)
        if (data != null) {
            RingingComponents.get(this).controller.onDecline(data)
        }
        finishTask()
    }

    private fun finishDelayed() {
        Handler(Looper.getMainLooper()).postDelayed({
            finishTask()
        }, 1000)
    }

    private fun finishTask() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            finishAndRemoveTask()
        } else {
            finish()
        }
    }

    override fun onDestroy() {
        wakeLock?.release()
        wakeLock = null
        if (isEndedReceiverRegistered) {
            unregisterReceiver(endedIncomingCallBroadcastReceiver)
            isEndedReceiverRegistered = false
        }
        super.onDestroy()
    }

    override fun onBackPressed() {}
}
