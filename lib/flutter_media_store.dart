import 'package:flutter_media_store/flutter_media_store_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterMediaStore {
  /// Save a file to the MediaStore with success and error handling.
  Future<void> saveFile({
    required List<int> fileData,
    required String mimeType,
    required String rootFolderName,
    required String folderName,
    required String fileName,
    required Function(String uri, String filePath) onSuccess, // Update to accept both URI and filePath
    required Function(String errorMessage) onError,
  }) async {
    if (!await _checkAndRequestPermissions()) {
      onError('Permission denied. Cannot save file.');
      return;
    }

    try {
      final result = await FlutterMediaStorePlatformInterface.instance.saveFileToMediaStore(
        fileData: fileData,
        fileName: fileName,
        mimeType: mimeType,
        rootFolderName: rootFolderName,
        folderName: folderName,
        onSuccess: onSuccess,
        onError: onError
      );

      if (result.startsWith("IOException") || result.startsWith("Failed")) {
        onError(result);
      } else {
        // Split the result to extract URI and filePath
        final parts = result.split('|');
        if (parts.length == 2) {
          onSuccess(parts[1], parts[0]); // URI and filePath
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
    required Function(String result) onSuccess, // Callback for success with result
    required Function(String errorMessage) onError, // Callback for error with message
  }) async {

    if (!await _checkAndRequestPermissions()) {
      onError('Permission denied. Cannot append data.');
      return;
    }

    try {
      final result = await FlutterMediaStorePlatformInterface.instance.appendDataToMediaStore(
        uri: uri,
        fileData: fileData,
        onSuccess: (String result) {
          print(result);
        },
        onError: (String errorMessage) {
          print(errorMessage);
        },
      );

      if (result.startsWith("IOException") || result.startsWith("Failed")) {
        // Failure, invoke onError with the error message
        onError(result);
      } else {
        // Success, invoke onSuccess with result
        onSuccess(result);
      }
    } catch (e) {
      onError('Error: ${e.toString()}');
    }
  }

  /// Check and request necessary permissions
  Future<bool> _checkAndRequestPermissions() async {
    // Check for storage permissions (e.g., WRITE_EXTERNAL_STORAGE on Android)
    PermissionStatus status = await Permission.storage.request();

    // Check if permission is granted
    return status.isGranted;
  }
}
