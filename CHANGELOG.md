## 1.3.1

* **Updated License**: Changed the license to **MIT** for improved clarity and broader adoption.


## 1.3.0

* **Added** support for picking files directly from the device's MediaStore.
  - Allows users to select files such as images, audio, video, and documents.
  - Supports both **single select** and **multi-select** options.

## 1.2.1

* **Removed** dependency on device_info_plus and replaced it with a native method to retrieve the Android SDK version.
* **Improved** SDK version check to dynamically handle permissions based on the actual Android version without the need for additional packages.
* **Enhanced** permission flow to work seamlessly with Android 10+ versions.

## 1.2.0

* **Added** support for `MANAGE_EXTERNAL_STORAGE` permission for Android 11+.
* **Improved** permission handling with dynamic requests based on Android version.
* **Bug fixes** for better performance and compatibility with scoped storage.
* **Updated** permission flow to handle Android 10 and below with `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE`.


## 1.1.0

* **Added** `appendDataToFile` method for appending data to existing files in **MediaStore**.
* **Improved** permission handling and error messages.
* **Bug fixes** for better file-saving and appending performance.
* **Enhanced** compatibility with various file types and custom folder saving.

## 1.0.0:

* **Initial Release**:
  - A plugin to save various types of files (images, videos, audio, documents, etc.) directly to Android's **MediaStore**.
  - Supports saving file types like **PNG, JPG, PDF, CSV, TXT, XML, JSON, MP3, MP4, ZIP, TAR**.
  - Automatically handles storage permissions for both read and write access.
  - Works across **all Android versions**.
  - Supports seamless integration with the Android storage system, providing an easy way to save files from your Flutter app.
  - Simplifies file-saving process with a single method: `saveFile`.
  - MIME type support for each file format to ensure compatibility.
  - Allows the saving of files into specific folders inside the **MediaStore** (e.g., custom folder names).
  - Automatically requests permissions if they are not granted initially.