import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/auth/AuthenticationService.dart';
import 'package:example/documents/user/UserDocumentService.dart';
import 'package:example/storage/StorageService.dart';
import 'package:example/storage/components/circularImagePicker.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  final Function(UserDocument) onUserCreated;

  const CreateUser({super.key, required this.onUserCreated});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  var _isHovering = false;
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _nameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  late UserDocument profile;
  bool isUploading = false;
  late String imageUrl = "";
  double progress = 0.0;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Save Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                _nameTextController.clear();
                _phoneTextController.clear();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> onUploadPressed() async {
    try {
      var file = await StorageService().pickFiles(false);
      setState(() {
        isUploading = true;
      });
      var url = await StorageService().upload(
        file[0],
        onProgress: (p) {
          setState(() {
            progress = p;
          });
        },
      );
      setState(() {
        print(url);
        imageUrl = url;
      });
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      _showErrorDialog(context, e.message ?? 'Error uploading!');
    }
    setState(() {
      isUploading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var node in [
      _nameFocus,
      _phoneFocus,
    ]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String label, bool hasFocus) {
    return InputDecoration(
      labelText: hasFocus ? null : label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shadow = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 6,
          spreadRadius: -4,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        double formWidth;
        EdgeInsets padding;

        if (width < 600) {
          formWidth = width * 0.9; // mobile
          padding = const EdgeInsets.all(16);
        } else if (width < 1100) {
          formWidth = width * 0.7; // tablet
          padding = const EdgeInsets.all(24);
        } else {
          formWidth = width * 0.5; // desktop
          padding = const EdgeInsets.all(10);
        }

        return Center(
          child: SizedBox(
            width: formWidth,
            child: Container(
              padding: padding,
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(color: Colors.black, fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: isUploading
                        ? Text('${progress.toString()}%')
                        : CircularImagePicker(
                            imageUrl: imageUrl,
                            onUploadPressed: onUploadPressed,
                          ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _nameFocus,
                      controller: _nameTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _nameTextController.text.isNotEmpty
                          ? inputDecoration('', _nameFocus.hasFocus)
                          : inputDecoration('Name', _nameFocus.hasFocus),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: shadow,
                    child: TextField(
                      focusNode: _phoneFocus,
                      controller: _phoneTextController,
                      obscureText: false,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: _phoneTextController.text.isNotEmpty
                          ? inputDecoration('', _phoneFocus.hasFocus)
                          : inputDecoration('Phone', _phoneFocus.hasFocus),
                    ),
                  ),
                  const SizedBox(height: 16),

                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovering = true),
                    onExit: (_) => setState(() => _isHovering = false),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _isHovering
                            ? Colors.black
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final currentUser = AuthenticationService().currentUser;
                        final user = UserDocument(
                          id: "",
                          image: imageUrl != "" ? imageUrl : "",
                          name: _nameTextController.text,
                          email: currentUser?.email ?? "",
                          phone: _phoneTextController.text,
                          dateCreated: DateTime.now(),
                          dateUpdated: DateTime.now(),
                        );
                        try {
                          profile = await UserDocumentService()
                              .createUserDocument(user);
                          widget.onUserCreated(profile);
                        } on FirebaseException catch (e) {
                          if (!context.mounted) return;
                          _showErrorDialog(
                            context,
                            e.message ?? "Authentication failed.",
                          );
                        }
                      },
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
