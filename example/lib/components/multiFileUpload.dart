import 'package:example/models/StorageService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  List<PlatformFile> selectedFiles = [];
  bool isUploading = false;
  String uploadingFile = "";
  List<String> uploaded = [];
  List<String> urls = [];
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

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                          trailing: () {
                            if (isUploading && file.name == uploadingFile) {
                              return Text('${progress.toString()}%');
                            }

                            if (uploaded.contains(file.name)) {
                              return const Text("100%");
                            }

                            return IconButton(
                              icon: const Icon(
                                Icons.cancel_rounded,
                                color: Colors.black,
                              ),
                              onPressed: () => removeFile(index),
                            );
                          }(),
                        ),
                      );
                    },
                  ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    var files = await StorageService().pickFiles(true);
                    setState(() {
                      selectedFiles.addAll(files);
                    });
                  } catch (e) {
                    if (!mounted) return;
                    _showErrorDialog(context, e.toString());
                  }
                },
                icon: const Icon(Icons.insert_drive_file),
                label: const Text('Select Files'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: selectedFiles.isEmpty
                    ? null
                    : () async {
                        for (final file in selectedFiles) {
                          setState(() {
                            uploadingFile = file.name;
                            isUploading = true;
                          });
                          try {
                            final url = await StorageService().upload(
                              file,
                              onProgress: (p) {
                                setState(() {
                                  progress = p;
                                });
                              },
                            );
                            urls.add(url);
                            uploaded.add(file.name);
                          } on FirebaseException catch (e) {
                            if (!context.mounted) return;
                            _showErrorDialog(
                              context,
                              e.message ?? 'Error uploading ${file.name}',
                            );
                          }
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                child: const Text("Upload Files"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
