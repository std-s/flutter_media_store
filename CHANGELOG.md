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