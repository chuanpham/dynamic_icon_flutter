package com.chuanpham.dynamic_icon_flutter
import android.app.Activity
import android.app.Application
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build.*
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.startActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.StringBuilder
import android.content.Context
import java.lang.ref.WeakReference
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** DynamicIconFlutterPlugin */
class DynamicIconFlutterPlugin : ContextAwarePlugin() {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    override val pluginName: String = "dynamic_icon_flutter"

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

    //dynamically change app icon
    private fun setIcon(targetIcon: String, activitiesArray: List<String>) {
        val packageManager: PackageManager = applicationContext!!.packageManager
        val packageName = applicationContext!!.packageName
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
                    ComponentName(packageName!!, "$packageName.$value"),
                    action, PackageManager.DONT_KILL_APP
            )
        }

        //finish current activity & launch new intent to prevent app from killing itself!
        //check if android version is greater than 8
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            val intent = Intent()
            intent.setClassName(packageName!!, className.toString())
            intent.action = Intent.ACTION_MAIN
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TASK
             this.activity?.finish()
            startActivity(this.applicationContext!!, intent, null)
        }
    }

}


abstract class ContextAwarePlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {

    abstract val pluginName: String

    private lateinit var channel : MethodChannel

    protected val activity get() = activityReference.get()
    protected val applicationContext get() =
        contextReference.get() ?: activity?.applicationContext

    private var activityReference = WeakReference<Activity>(null)
    private var contextReference = WeakReference<Context>(null)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityReference = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityReference.clear()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityReference = WeakReference(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activityReference.clear()
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, pluginName)
        channel.setMethodCallHandler(this)

        contextReference = WeakReference(flutterPluginBinding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
