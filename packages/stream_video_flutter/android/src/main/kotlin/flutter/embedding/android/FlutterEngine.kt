package io.flutter.embedding.android

import android.app.Activity

val Activity.engine get() = when (this) {
    is FlutterActivity -> flutterEngine
    is FlutterFragmentActivity -> flutterEngine
    else -> null
}
