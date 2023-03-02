package com.example.example

import android.content.Context
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity: FlutterActivity() {

    override fun onResume() {
        super.onResume()
        Log.d("MainActivity", "[onResume] application: $application")
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        val engine = FlutterEngineCache.getInstance().get("stream_flutter_background_engine")
        Log.i("MainActivity", "[provideFlutterEngine] engine: $engine")
        return engine
    }

}
