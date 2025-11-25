import 'package:example/pages/submit-email.dart';
import 'package:flutter/material.dart';

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _subjectFocus = FocusNode();
  final _messageFocus = FocusNode();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _subjectTextController = TextEditingController();
  final _messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var node in [_nameFocus, _emailFocus, _subjectFocus, _messageFocus]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
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
                      "Contact Me",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Name
                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _nameFocus,
                        controller: _nameTextController,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _nameTextController.text.isNotEmpty
                            ? inputDecoration('', _nameFocus.hasFocus)
                            : inputDecoration('Name', _nameFocus.hasFocus),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    Container(
                      decoration: shadow,
                      child: TextFormField(
                        focusNode: _emailFocus,
                        controller: _emailTextController,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _emailTextController.text.isNotEmpty
                            ? inputDecoration('', _emailFocus.hasFocus)
                            : inputDecoration('Email', _emailFocus.hasFocus),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex =
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subject
                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _subjectFocus,
                        controller: _subjectTextController,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _subjectTextController.text.isNotEmpty
                            ? inputDecoration('', _subjectFocus.hasFocus)
                            : inputDecoration('Subject', _subjectFocus.hasFocus),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Message
                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _messageFocus,
                        controller: _messageTextController,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 10,
                        decoration: _messageTextController.text.isNotEmpty
                            ? inputDecoration('', _messageFocus.hasFocus)
                            : inputDecoration('Message', _messageFocus.hasFocus),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SubmitEmailButton(
                      name: _nameTextController.text,
                      email: _emailTextController.text,
                      subject: _subjectTextController.text,
                      message: _messageTextController.text,
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
