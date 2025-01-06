import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_store/flutter_media_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = 'Press the button to save a file';
  String rootFolderName = 'FlutterMediaStore';

  /// Update the message state
  void _updateMessage(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }

  /// Save file to MediaStore
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
          _updateMessage('✅ File saved successfully: $filePath');

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MediaStore File Saver'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(height: 20, thickness: 2),
                const SizedBox(height: 20),
                // File saving buttons in a Wrap widget
                Wrap(
                  spacing: 10, // Horizontal spacing between buttons
                  runSpacing: 10, // Vertical spacing between rows
                  alignment: WrapAlignment.center, // Center the buttons
                  children: [
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/img/sample1.png',
                        mimeType: 'image/png',
                        fileName: 'sample1.png',
                        folderName: 'Images/png',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save PNG Image'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/img/sample2.jpg',
                        mimeType: 'image/jpeg',
                        fileName: 'sample2.jpg',
                        folderName: 'Images/jpg',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save JPG Image'),
                    ),
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
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/txt/sample.txt',
                        mimeType: 'text/plain',
                        fileName: 'sample.txt',
                        folderName: 'Txt',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save TXT File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/pdf/sample.pdf',
                        mimeType: 'application/pdf',
                        fileName: 'sample.pdf',
                        folderName: 'Pdf',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save PDF File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                          assetPath: 'assets/xml/sample.xml',
                          mimeType: 'application/xml',
                          fileName: 'sample.xml',
                          folderName: 'Xml',
                          rootFolderName: rootFolderName),
                      child: const Text('Save XML File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                          assetPath: 'assets/mp3/sample.mp3',
                          mimeType: 'audio/mpeg',
                          fileName: 'sample.mp3',
                          folderName: 'Music',
                          rootFolderName: rootFolderName),
                      child: const Text('Save MP3 File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                          assetPath: 'assets/mp4/sample.mp4',
                          mimeType: 'video/mp4',
                          fileName: 'sample.mp4',
                          folderName: 'Videos',
                          rootFolderName: rootFolderName),
                      child: const Text('Save MP4 File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/zip/sample.zip',
                        mimeType: 'application/zip',
                        fileName: 'sample.zip',
                        folderName: 'Archives/zip',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save ZIP File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/tar/sample.tar',
                        mimeType: 'application/x-tar',
                        fileName: 'sample.tar',
                        folderName: 'Archives/tar',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save TAR File'),
                    ),
                    ElevatedButton(
                      onPressed: () => saveFile(
                        assetPath: 'assets/sql/sample.sql',
                        mimeType: 'application/sql', // MIME type for SQL files
                        fileName: 'sample.sql',
                        folderName: 'SQL',
                        rootFolderName: rootFolderName,
                      ),
                      child: const Text('Save SQL File'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
