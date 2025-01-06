# Flutter Media Store Plugin

Welcome to the **Flutter Media Store Plugin**! This plugin allows you to save various types of files (images, videos, audio, documents, etc.) directly to the device's **Android MediaStore**, enabling seamless integration with Android's storage system. It supports **all Android versions**.

## Features

- **Save files to MediaStore**: Easily save files such as images, audio, video, CSV, text, and more.
- **Append data to existing files**: Allows appending data to files already saved in MediaStore (e.g., adding additional content to existing files).
- **Android-specific**: This plugin currently supports Android devices.
- **Automatic Permission Handling**: The plugin checks and requests storage permissions to ensure proper functionality.
- **Cross-file type support**: Save different file types like PNG, JPG, PDF, CSV, TXT, XML, Json, MP3, MP4, ZIP, Tar etc.

## Scoped Storage and MediaStore

### Scoped Storage

**Scoped Storage** is a feature introduced in Android 10 (API level 29) to improve user privacy and security. It limits direct access to the file system, allowing apps to access only specific types of data and files in designated locations, such as the app’s private storage and the public directories within shared storage (like photos, videos, and documents). This prevents apps from accessing sensitive data in areas like the root of the file system or other apps' private storage.

### MediaStore

**MediaStore** is part of Android’s content provider system that provides access to media files such as images, audio, and videos stored on the device. With **MediaStore**, apps can read and write media files while complying with scoped storage restrictions. Instead of directly writing to arbitrary locations on the device, MediaStore allows apps to interact with media content in a structured and secure manner.

### Flutter Media Store Plugin & Scoped Storage Integration

The **Flutter Media Store Plugin** leverages **Scoped Storage** to manage the storage of files (such as images, videos, and audio) directly within the device’s **Android MediaStore**. This integration ensures that your app can save files in a manner that is compliant with Android's scoped storage model, allowing you to access and save files within the appropriate media collections like images, videos, and audio.

#### Key Benefits:

- **Automatic Permission Handling**: The plugin checks for the necessary permissions (like `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE`) to interact with the MediaStore and ensures that the app complies with Android's storage policies.

- **Cross-file Type Support**: It allows the saving of various file types (images, audio, video, documents, and more) directly into Android’s **MediaStore**. This makes it easy to manage and retrieve files from the system's media collections.

- **Scoped Storage Compliant**: By utilizing the MediaStore API, the plugin ensures that files are saved in a structured way within public directories that are accessible according to scoped storage rules. This ensures that the app does not have access to other apps' data or private file locations, which aligns with Android's privacy-centric storage model.

This approach ensures that the **Flutter Media Store Plugin** is fully compatible with modern Android storage policies while providing an easy-to-use method for saving and managing media files directly within the Android system's storage framework.


## Demo GIF

Watch this demo GIF to see the plugin in action:

![Flutter Media Store Demo](https://ik.imagekit.io/puy8cmyj2/flutter_media_store.gif?updatedAt=1735888257697)

## Installation

To get started with the **Flutter Media Store Plugin**, follow these steps:

1. **Add the dependency** to your `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_media_store: ^1.2.1
    ```

2. **Run** `flutter pub get` to fetch the plugin and its dependencies.

3. **Android Permissions**: For the plugin to work, you need to add the necessary permissions to your Android app:

   In `android/app/src/main/AndroidManifest.xml`, add the following lines:

    ```xml
    <!-- Permission to read files from external storage (Required for API level <= 29) -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="29" />

    <!-- Permission to write files to external storage (Required for API level <= 29, deprecated in API level 30 and above. Use MANAGE_EXTERNAL_STORAGE for API >= 30) -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29" />

    <!-- Permission to manage all files on external storage (Required for API level >= 30, covers reading and writing) -->
    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
    ```

4. **Handling Permissions**: The plugin automatically requests permission to access the device storage. If permission is denied, it displays a message to the user prompting them to grant permission.

## Usage

Once the plugin is installed and permissions are configured, you can start saving files to the device's MediaStore.

### Example Code

The main method to save a file is `saveFile` & `appendDataToFile`. Here's an example of how to use it:

```dart
Future<void> saveFile({
   required String assetPath,
   required String mimeType,
   required String fileName,
   required String rootFolderName,
   required String folderName,
}) async {
   final flutterMediaStorePlugin = FlutterMediaStore();

   try {
      // Load file from assets using rootBundle
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List fileData = byteData.buffer.asUint8List();

      // Save the file using the plugin and handle success/error via callbacks
      await flutterMediaStorePlugin.saveFile(
         fileData: fileData,
         mimeType: mimeType,
         rootFolderName: rootFolderName,
         folderName: folderName,
         fileName: fileName,
         onSuccess: (String uri, String filePath) {
            // Callbacks on success
            _updateMessage('✅ File saved successfully: $filePath.toString()');

            print('uri: ${uri.toString()}');
            print('path: ${filePath.toString()}');

            // Appends data to an existing file in the MediaStore using the given URI.
            flutterMediaStorePlugin.appendDataToFile(
               uri: uri,
               fileData: fileData, // append new data
               onSuccess: (result) {
                  print(result);
               },
               onError: (errorMessage) {
                  print(errorMessage);
               },
            );

         },
         onError: (String errorMessage) {
            // Callbacks on error
            _updateMessage('❌ Failed to save file: $errorMessage');
         },
      );
   } catch (e) {
      // Catch and log any errors that may occur during the process
      _updateMessage('❌ Error loading file from assets: ${e.toString()}');
   }
}
```

## MIME Type List
Below is a list of supported MIME types for different file types:

```xml
   PNG Image: image/png
        JPG Image: image/jpeg
        PDF File: application/pdf
        CSV File: text/csv
        TXT File: text/plain
        XML File: application/xml
        JSON File: application/json
        MP3 File: audio/mpeg
        MP4 Video: video/mp4
        ZIP Archive: application/zip
        TAR Archive: application/x-tar
```

Use the appropriate MIME type for the file format you are saving.

### MIME Use Example



```dart
ElevatedButton(
      onPressed: () => saveFile(
      assetPath: 'assets/csv/sample.csv',
      mimeType: 'text/csv',
      fileName: 'sample.csv',
      folderName: 'Csv',
      rootFolderName: rootFolderName,
   ),
child: const Text('Save CSV File'),
),
```

## License

This project is licensed under the BSD License - see the [LICENSE](LICENSE) file for details.


## Authors

- [@GitHub/Rajkumarlohar65](https://github.com/Rajkumarlohar65)
- rajkumarlohar65@gmail.com


## 🔗 Links

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rajkumar-lohar-5b318a207)


