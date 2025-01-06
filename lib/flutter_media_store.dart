import 'package:flutter_media_store/flutter_media_store_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; // For Platform checks

class FlutterMediaStore {
  /// Save a file to the MediaStore with success and error handling.
  Future<void> saveFile({
    required List<int> fileData,
    required String mimeType,
    required String rootFolderName,
    required String folderName,
    required String fileName,
    required Function(String uri, String filePath) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    if (!await _checkAndRequestPermissions()) {
      onError('Permission denied. Cannot save file.');
      return;
    }

    try {
      final result = await FlutterMediaStorePlatformInterface.instance
          .saveFileToMediaStore(
        fileData: fileData,
        fileName: fileName,
        mimeType: mimeType,
        rootFolderName: rootFolderName,
        folderName: folderName,
        onSuccess: onSuccess,
        onError: onError,
      );

      if (result.startsWith("IOException") || result.startsWith("Failed")) {
        onError(result);
      } else {
        final parts = result.split('|');
        if (parts.length == 2) {
          onSuccess(parts[1], parts[0]);
        } else {
          onError("Unexpected result format: $result");
        }
      }
    } catch (e) {
      onError('Error: ${e.toString()}');
    }
  }

  /// Append data to an existing file in the MediaStore
  Future<void> appendDataToFile({
    required String uri,
    required List<int> fileData,
    required Function(String result) onSuccess,
    required Function(String errorMessage) onError,
  }) async {
    if (!await _checkAndRequestPermissions()) {
      onError('Permission denied. Cannot append data.');
      return;
    }

    try {
      final result = await FlutterMediaStorePlatformInterface.instance
          .appendDataToMediaStore(
        uri: uri,
        fileData: fileData,
        onSuccess: (String result) => onSuccess(result),
        onError: (String errorMessage) => onError(errorMessage),
      );

      if (result.startsWith("IOException") || result.startsWith("Failed")) {
        onError(result);
      } else {
        onSuccess(result);
      }
    } catch (e) {
      onError('Error: ${e.toString()}');
    }
  }

  /// Check and request necessary permissions
  Future<bool> _checkAndRequestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final sdkInt = await _getAndroidSdkVersion();

      if (sdkInt >= 30) {
        // Android 11 and above
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        // Android 10 and below
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }

    return true; // No permissions needed for non-Android platforms
  }

  /// Method to get Android SDK version
  Future<int> _getAndroidSdkVersion() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.version.sdkInt; // Fetch the SDK version
    }

    return 0; // Non-Android or unknown platform
  }
}
