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

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.flutter_media_store/media_store")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
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
      // For Android 10 and above
      saveFileUsingMediaStore(resolver, fileData, fileName, mimeType, relativePath)
    } else {
      // For Android versions below Android 10
      saveFileDirectly(fileData, fileName, relativePath)
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

        // Get the real file path from the content URI
//        val filePath = getFilePathFromUri(uri)
        val filePath = uri.toString()
        filePath ?: "File saved but path could not be retrieved"
      } catch (e: IOException) {
        "IOException: ${e.localizedMessage}" // return error message
      }
    } else {
      "Failed to create URI" // return error message
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
      file.absolutePath // return the file path on success
    } catch (e: IOException) {
      "IOException: ${e.localizedMessage}" // return error message
    }
  }

  // Function to append data to an existing file in MediaStore
  private fun appendDataToFile(
    resolver: ContentResolver?,
    uri: Uri,
    dataToAppend: ByteArray
  ): String {
    return try {
      resolver?.openOutputStream(uri, "wa")?.use { outputStream ->
        outputStream.write(dataToAppend)
        "Data appended successfully"
      } ?: "Failed to open output stream"
    } catch (e: IOException) {
      "IOException: ${e.localizedMessage}"
    }
  }



  // ActivityAware methods
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
