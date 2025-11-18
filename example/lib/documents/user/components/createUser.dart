import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/auth/AuthenticationService.dart';
import 'package:example/documents/user/UserDocumentService.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  var _isHovering = false;
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _address1Focus = FocusNode();
  final _address2Focus = FocusNode();
  final _cityFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _zipFocus = FocusNode();
  final _nameTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _address1TextController = TextEditingController();
  final _address2TextController = TextEditingController();
  final _cityTextController = TextEditingController();
  final _stateTextController = TextEditingController();
  final _zipTextController = TextEditingController();
  late UserDocument profile;

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
                _address1TextController.clear();
                _address2TextController.clear();
                _cityTextController.clear();
                _stateTextController.clear();
                _zipTextController.clear();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    for (var node in [
      _nameFocus,
      _phoneFocus,
      _address1Focus,
      _address2Focus,
      _cityFocus,
      _stateFocus,
      _zipFocus,
    ]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _address1Focus.dispose();
    _address2Focus.dispose();
    _cityFocus.dispose();
    _stateFocus.dispose();
    _zipFocus.dispose();
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
            child: SingleChildScrollView(
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

                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _address1Focus,
                        controller: _address1TextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _address1TextController.text.isNotEmpty
                            ? inputDecoration('', _address1Focus.hasFocus)
                            : inputDecoration(
                                'Address 1',
                                _address1Focus.hasFocus,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _address2Focus,
                        controller: _address2TextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _address2TextController.text.isNotEmpty
                            ? inputDecoration('', _address2Focus.hasFocus)
                            : inputDecoration(
                                'Address 2',
                                _address2Focus.hasFocus,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _cityFocus,
                        controller: _cityTextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _cityTextController.text.isNotEmpty
                            ? inputDecoration('', _cityFocus.hasFocus)
                            : inputDecoration('Password', _cityFocus.hasFocus),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _stateFocus,
                        controller: _stateTextController,
                        obscureText: false,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _stateTextController.text.isNotEmpty
                            ? inputDecoration('', _stateFocus.hasFocus)
                            : inputDecoration('Password', _stateFocus.hasFocus),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _zipFocus,
                        controller: _zipTextController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _zipTextController.text.isNotEmpty
                            ? inputDecoration('', _zipFocus.hasFocus)
                            : inputDecoration('Password', _zipFocus.hasFocus),
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
                          final currentUser =
                              AuthenticationService().currentUser;
                          final user = UserDocument(
                            id: "",
                            image: "",
                            name: _nameTextController.text,
                            email: currentUser?.email ?? "",
                            phone: _phoneTextController.text,
                            address1: _address1TextController.text,
                            address2: _address2TextController.text,
                            city: _cityTextController.text,
                            state: _stateTextController.text,
                            zip: _zipTextController.text,
                            dateCreated: DateTime.now(),
                            dateUpdated: DateTime.now(),
                          );
                          try {
                            profile = await UserDocumentService()
                                .createUserDocument(user);
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
          ),
        );
      },
    );
  }
}
