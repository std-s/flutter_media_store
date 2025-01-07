import 'package:flutter_media_store/flutter_media_store_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterMediaStorePlatformInterface extends PlatformInterface {
  FlutterMediaStorePlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static FlutterMediaStorePlatformInterface _instance =
      FlutterMediaStoreMethodChannel();

  static FlutterMediaStorePlatformInterface get instance => _instance;

  static set instance(FlutterMediaStorePlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<int> getAndroidSdkVersionNative();

  // Method to open the file picker and return the selected file URI
  Future<String> pickFile({
    required Function(String uri) onFilePicked,
    required Function(String errorMessage) onError,
  });


  Future<String> saveFileToMediaStore({
    required String rootFolderName,
    required String folderName,
    required String mimeType,
    required List<int> fileData,
    required String fileName,
    required Function(String uri, String filePath)
        onSuccess, // Update to accept both URI and filePath
    required Function(String errorMessage) onError, // Callback for error
  });

  /// Append data to an existing file in the MediaStore
  Future<String> appendDataToMediaStore({
    required String uri,
    required List<int> fileData,
    required Function(String result)
        onSuccess, // Callback for success with result
    required Function(String errorMessage)
        onError, // Callback for error with message
  });

}
