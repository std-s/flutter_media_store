# Flutter Media Store Plugin

Welcome to the **Flutter Media Store Plugin**! This plugin allows you to save various types of files (images, videos, audio, documents, etc.) directly to the device's **Android MediaStore**, enabling seamless integration with Android's storage system. It supports **all Android versions**.

## Features

- **Save files to MediaStore**: Easily save files such as images, audio, video, CSV, text, and more.

- **Append data to existing files**: Allows appending data to files already saved in MediaStore (e.g., adding additional content to existing files).

- **Android-specific**: This plugin currently supports Android devices.
- **Automatic Permission Handling**: The plugin checks and requests storage permissions to ensure proper functionality.
- **Cross-file type support**: Save different file types like PNG, JPG, PDF, CSV, TXT, XML, Json, MP3, MP4, ZIP, Tar etc.

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
      flutter_media_store: ^1.1.0
    ```

2. **Run** `flutter pub get` to fetch the plugin and its dependencies.

3. **Android Permissions**: For the plugin to work, you need to add the necessary permissions to your Android app:

   In `android/app/src/main/AndroidManifest.xml`, add the following lines:

    ```xml
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    ```

4. **Handling Permissions**: The plugin automatically requests permission to access the device storage. If permission is denied, it displays a message to the user prompting them to grant permission.

## Usage

Once the plugin is installed and permissions are configured, you can start saving files to the device's MediaStore.

### Example Code

The main method to save a file is `saveFile`. Here's an example of how to use it:

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


## Developer

**Rajkumar Lohar**

For any questions or support, please reach out to:

- **Email**: rajkumarlohar65@gmail.com

