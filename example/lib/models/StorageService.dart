import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> upload(
    PlatformFile file, {
    void Function(double progress)? onProgress,
  }) async {
    if (file.bytes == null) {
      throw Exception('No file bytes found — this is required on web.');
    }

    final contentType = lookupMimeType(file.name) ?? 'application/octet-stream';
    final storageRef = _storage.ref().child('uploads/${file.name}');

    try {
      final uploadTask = storageRef.putData(
        file.bytes!,
        SettableMetadata(contentType: contentType),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        if (onProgress != null) onProgress(progress);

        switch (snapshot.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            print("Upload paused.");
            break;
          case TaskState.canceled:
            print("Upload canceled.");
            break;
          case TaskState.error:
            print("Upload error occurred.");
            break;
          case TaskState.success:
            print("Upload successful.");
            break;
        }
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Upload failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during upload: $e');
    }
  }

  Future<List<PlatformFile>> pickFiles(bool multiple) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: multiple,
      withData: true,
    );

    if (result == null) return [];
    return result.files;
  }

  Future<void> deleteByUrl(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Exception('Delete failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during delete: $e');
    }
  }

  Future<void> deleteByPath(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Exception('Delete failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during delete: $e');
    }
  }
}

