import 'package:example/auth/AuthenticationService.dart';
import 'package:example/auth/components/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _isHovering = false;
  final _emailFocus = FocusNode();
  final _password = FocusNode();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  late UserCredential userCredential;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                _emailTextController.clear();
                _passwordTextController.clear();
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
    for (var node in [_emailFocus, _password]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _password.dispose();
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
                      "Login",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    Material(child: Center(
  child: Container(
    width: 400,        // <-- FIXED SIZE for debugging
    height: 400,
    child: Container(
    decoration: BoxDecoration(
      color: Colors.white,                  // needed for shadow visibility
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
    child: ClipRRect(                       // keeps nice rounded content
      borderRadius: BorderRadius.circular(16),
      child: SignUpForm()
    ),
    ),
  ),),
      ),
                              ),
                            );
                          },
                          child: Text("SignUp"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

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
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Container(
                      decoration: shadow,
                      child: TextField(
                        focusNode: _password,
                        controller: _passwordTextController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: _passwordTextController.text.isNotEmpty
                            ? inputDecoration('', _password.hasFocus)
                            : inputDecoration('Password', _password.hasFocus),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // send forgot password email
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
                          try {
                            userCredential = await AuthenticationService()
                                .authenticateUser(
                                  _emailTextController.text,
                                  _passwordTextController.text,
                                );
                          } on FirebaseAuthException catch (e) {
                            if (!context.mounted) return;
                            _showErrorDialog(
                              context,
                              e.message ?? "Authentication failed.",
                            );
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),

                    // sign in with google
                    // sign in with facebook
                    // sign in with apple
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
