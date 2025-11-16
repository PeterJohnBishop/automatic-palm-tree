import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  List<PlatformFile> selectedFiles = [];

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    setState(() {
      selectedFiles.addAll(result.files);
    });
  }

  Future<void> upload(PlatformFile file) async {
    if (file.bytes == null) {
      print('No file bytes found — this is required on web.');
      return;
    }

    final contentType = lookupMimeType(file.name) ?? 'application/octet-stream';

    final storageRef = FirebaseStorage.instance.ref().child(
      'uploads/${file.name}',
    );

    final uploadTask = storageRef.putData(
      file.bytes!,
      SettableMetadata(contentType: contentType),
    );

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });

    final snapshot = await uploadTask.whenComplete(() {});

    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('Uploaded. URL: $downloadUrl');
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  Future<void> uploadFiles(List<PlatformFile> files) async {
    for (final file in files) {
      await upload(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: pickFiles,
            icon: const Icon(Icons.insert_drive_file),
            label: const Text('Select Files'),
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: selectedFiles.isEmpty
                ? const Center(child: Text("No files selected."))
                : ListView.builder(
                    itemCount: selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = selectedFiles[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(file.name),
                          subtitle: Text(
                            "${(file.size / 1024).toStringAsFixed(2)} KB",
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: Colors.black,
                            ),
                            onPressed: () => removeFile(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: selectedFiles.isEmpty
                ? null
                : () => uploadFiles(selectedFiles),
            child: const Text("Upload Files"),
          ),
        ),
      ],
    );
  }
}
