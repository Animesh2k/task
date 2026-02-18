package com.example.weavers_flutter_base_project
import android.content.Intent
import com.singular.flutter_sdk.SingularBridge
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity(){
    override fun onNewIntent(intent: Intent) {
  super.onNewIntent(intent)
  SingularBridge.onNewIntent(intent);
}
}
