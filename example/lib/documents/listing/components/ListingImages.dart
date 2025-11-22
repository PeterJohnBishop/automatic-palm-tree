import 'package:example/storage/StorageService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ListingImages extends StatefulWidget {
  final double width;
  final double height;
  const ListingImages({super.key, required this.width, required this.height});

  @override
  State<ListingImages> createState() => _ListingImagesState();
}

class _ListingImagesState extends State<ListingImages> {
  double width = 0;
  double height = 0;
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
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    double formWidth;
    double formHeight;
    EdgeInsets padding;

    if (width < 600) {
      formWidth = width * 0.9; // mobile
      formHeight = height * 0.9;
      padding = const EdgeInsets.all(16);
    } else if (width < 1100) {
      formWidth = width * 0.7; // tablet
      formHeight = height * 0.9;
      padding = const EdgeInsets.all(24);
    } else {
      formWidth = width * 0.6; // desktop
      formHeight = height * 0.4;
      padding = const EdgeInsets.all(10);
    }

    return Container(
      width: formWidth,
      height: formHeight,
      // color: Colors.red.withOpacity(0.2),
      decoration: BoxDecoration(
        color: Colors.white, // needed for shadow visibility
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: padding, child: Column(
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
              padding: padding,
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
              padding: padding,
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
    ),
    ),
    );
  }
}
