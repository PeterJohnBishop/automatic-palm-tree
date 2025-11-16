import 'package:example/storage/StorageService.dart';
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
  final storage = StorageService();
  double progress = 0.0;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedFiles = [];
                  progress = 0.0;
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

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

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  Future<void> uploadFiles(List<PlatformFile> files) async {
    for (final file in files) {
      try {
        final url = await storage.upload(
          file,
          onProgress: (p) {
            setState(() {
              progress = p;
            });
          },
        );
        print("Download URL: $url");
      } catch (e) {
        _showErrorDialog(
          context,
          'Error uploading ${file.name}: ${e.toString()}',
        );
      }
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
