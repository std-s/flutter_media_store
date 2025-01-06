package com.example.flutter_media_store

import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class FlutterMediaStorePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private var applicationContext: Context? = null

  // Method called when the plugin is attached to the engine.
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.flutter_media_store/media_store")
    channel.setMethodCallHandler(this)
  }

  // Method called when the plugin is detached from the engine.
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  // Method to handle method calls from Flutter
  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      // Method to save a file to MediaStore
      "saveFileToMediaStore" -> {
        val rootFolderName = call.argument<String>("rootFolderName")
        val folderName = call.argument<String>("folderName")
        val fileData = call.argument<ByteArray>("fileData")
        val fileName = call.argument<String>("fileName")
        val mimeType = call.argument<String>("mimeType")

        if (fileData != null && fileName != null && mimeType != null && rootFolderName != null && folderName != null) {
          val saveResult = saveFileToMediaStore(fileData, fileName, mimeType, rootFolderName, folderName)
          result.success(saveResult)
        } else {
          result.error("ARGUMENT_ERROR", "Invalid arguments", null)
        }
      }

      // Method to append data to a file in MediaStore
      "appendDataToMediaStore" -> {
        val uriString = call.argument<String>("uri")
        val fileData = call.argument<ByteArray>("fileData")

        if (uriString != null && fileData != null) {
          val uri = Uri.parse(uriString)
          val appendResult = appendDataToFile(applicationContext?.contentResolver, uri, fileData)
          result.success(appendResult)
        } else {
          result.error("ARGUMENT_ERROR", "Invalid arguments", null)
        }
      }

      else -> result.notImplemented()
    }
  }

  // Method to save a file to MediaStore, using MediaStore API for Android 10 and above
  private fun saveFileToMediaStore(
    fileData: ByteArray,
    fileName: String,
    mimeType: String,
    rootFolderName: String,
    folderName: String
  ): String { // Change the return type to String
    val relativePath = "Download/$rootFolderName/$folderName"
    val resolver = applicationContext?.contentResolver

    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      // For Android 10 and above, use MediaStore API to save the file
      saveFileUsingMediaStore(resolver, fileData, fileName, mimeType, relativePath)
    } else {
      // For Android versions below Android 10, save the file directly
      saveFileDirectly(fileData, fileName, relativePath)
    }
  }

  private fun saveFileUsingMediaStore(
    resolver: ContentResolver?,
    fileData: ByteArray,
    fileName: String,
    mimeType: String,
    relativePath: String
  ): String {
    val values = ContentValues().apply {
      put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
      put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
      put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
    }

    val uri: Uri? = resolver?.insert(MediaStore.Files.getContentUri("external"), values)

    return if (uri != null) {
      try {
        resolver.openOutputStream(uri)?.use {
          it.write(fileData)
        }

        val filePath = getFilePathFromUri(uri)
        val fileUri = uri.toString()
        "$filePath|$fileUri" // Combine filePath and URI
      } catch (e: IOException) {
        "IOException: ${e.localizedMessage}"
      }
    } else {
      "Failed to create URI"
    }
  }

  private fun getFilePathFromUri(uri: Uri): String? {
    val cursor = applicationContext?.contentResolver?.query(uri, null, null, null, null)
    cursor?.use {
      val columnIndex = it.getColumnIndex(MediaStore.MediaColumns.DATA)
      if (it.moveToFirst()) {

        return it.getString(columnIndex)
      }
    }
    return null
  }


  // Method to append data to an existing file in MediaStore
  private fun appendDataToFile(
    resolver: ContentResolver?,
    uri: Uri,
    dataToAppend: ByteArray
  ): String {
    return try {
      // Open the output stream in append mode and write the data
      resolver?.openOutputStream(uri, "wa")?.use { outputStream ->
        outputStream.write(dataToAppend)
        "Data appended successfully"
      } ?: "Failed to open output stream"
    } catch (e: IOException) {
      "IOException: ${e.localizedMessage}" // Return error message if exception occurs
    }
  }

  private fun saveFileDirectly(
    fileData: ByteArray,
    fileName: String,
    relativePath: String
  ): String {
    val fileDir = File(applicationContext?.getExternalFilesDir(null), relativePath)

    if (!fileDir.exists()) {
      fileDir.mkdirs()
    }

    val file = File(fileDir, fileName)
    return try {
      val outputStream = FileOutputStream(file)
      outputStream.write(fileData)
      outputStream.close()
      "${file.absolutePath}|file://${file.absolutePath}" // Combine filePath and URI
    } catch (e: IOException) {
      "IOException: ${e.localizedMessage}"
    }
  }


  // Method to append data to the file directly (for Android versions below Android 10)
  private fun appendDataDirectly(
    fileData: ByteArray,
    fileName: String,
    relativePath: String
  ): String {
    val fileDir = File(applicationContext?.getExternalFilesDir(null), relativePath)

    // Ensure the directory exists, if not create it
    if (!fileDir.exists()) {
      fileDir.mkdirs()
    }

    val file = File(fileDir, fileName)

    return try {
      // Open the file in append mode (true)
      val outputStream = FileOutputStream(file, true)
      outputStream.write(fileData)  // Append the data
      outputStream.close()

      "Data appended successfully to ${file.absolutePath}"
    } catch (e: IOException) {
      "IOException: ${e.localizedMessage}" // Return error message if exception occurs
    }
  }

  // ActivityAware methods for handling activity lifecycle events

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    // No activity-specific logic for now
  }

  override fun onDetachedFromActivity() {
    // Clean up activity-related references if any
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // Handle activity detach for configuration changes if necessary
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    // Handle activity re-attachment after configuration changes if necessary
  }
}
