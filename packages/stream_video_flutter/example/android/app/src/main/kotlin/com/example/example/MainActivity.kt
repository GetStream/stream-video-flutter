package com.example.example

import android.content.Context
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity: FlutterActivity() {

    override fun onResume() {
        super.onResume()
        Log.d("MainActivity", "[onResume] application: $application")
    }

    override fun getCachedEngineId(): String {
        return MyApp.ENGINE_ID
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? =
        FlutterEngineCache.getInstance().get(MyApp.ENGINE_ID)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        /*MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "my-channel")
            .setMethodCallHandler { call, result ->
                if (call.method == "my-method") {
                    myMethod()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }*/
    }

    private fun myMethod() {
        // Do native stuff
    }

}
