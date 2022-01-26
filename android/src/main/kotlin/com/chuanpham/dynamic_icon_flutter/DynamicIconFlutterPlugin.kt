package com.chuanpham.dynamic_icon_flutter
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build.*
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.startActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.StringBuilder
import android.content.Context

/** DynamicIconFlutterPlugin */
class DynamicIconFlutterPlugin : FlutterPlugin, MethodCallHandler{
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dynamic_icon_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "setIcon") {
            try {
                val icon = call.argument<String>("icon")
                val listIcon = call.argument<List<String>>("listAvailableIcon")
                if (listIcon != null && icon != null) {
                    setIcon(icon, listIcon)
                }
                result.success(true)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    //dynamically change app icon
    private fun setIcon(targetIcon: String, activitiesArray: List<String>) {
        val packageManager: PackageManager = context.packageManager
        val packageName = context.packageName
        val className = StringBuilder()
        className.append(packageName)
        className.append(".")
        className.append(targetIcon)

        for (value in activitiesArray) {
            val action = if (value == targetIcon) {
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            } else {
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }
            packageManager.setComponentEnabledSetting(
                    ComponentName(packageName, className.toString()),
                    action, PackageManager.DONT_KILL_APP
            )
        }

        //finish current activity & launch new intent to prevent app from killing itself!
        //check if android version is greater than 8
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            val intent = Intent()
            intent.setClassName(packageName, className.toString())
            intent.action = Intent.ACTION_MAIN
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TASK
            //finish()
            startActivity(this.context, intent, null)
        }
    }

}
