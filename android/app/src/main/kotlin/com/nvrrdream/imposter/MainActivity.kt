
package com.nvrrdream.imposter

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val channelName = "imposter/update_installer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "canInstallPackages" -> {
                    val allowed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        packageManager.canRequestPackageInstalls()
                    } else {
                        true
                    }

                    result.success(allowed)
                }

                "openInstallSettings" -> {
                    try {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                            Uri.parse("package:$packageName")
                        )
                        startActivity(intent)
                        result.success(true)
                    } catch (exception: Exception) {
                        result.error("SETTINGS_ERROR", exception.message, null)
                    }
                }

                "installApk" -> {
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                            !packageManager.canRequestPackageInstalls()
                        ) {
                            result.error(
                                "PERMISSION_REQUIRED",
                                "Installation permission is required.",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        val path = call.argument<String>("path")
                            ?: throw IllegalArgumentException("APK path is missing.")

                        val apkFile = File(path)

                        if (!apkFile.exists() || !apkFile.isFile) {
                            throw IllegalArgumentException("APK file does not exist.")
                        }

                        val apkUri = FileProvider.getUriForFile(
                            this,
                            "$packageName.fileprovider",
                            apkFile
                        )

                        val intent = Intent(Intent.ACTION_VIEW).apply {
                            setDataAndType(
                                apkUri,
                                "application/vnd.android.package-archive"
                            )
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }

                        startActivity(intent)
                        result.success(true)
                    } catch (exception: Exception) {
                        result.error("INSTALL_ERROR", exception.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
