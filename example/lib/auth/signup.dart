import 'package:example/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var _isHovering = false;

  final _emailFocus = FocusNode();
  final _password = FocusNode();
  final _passwordVerification = FocusNode();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordVerificationTextController = TextEditingController();

  final storage = FlutterSecureStorage();
  String responseMessage = '';
  bool success = false;
  late UserCredential credential;

  Future<void> createUser(String email, String password) async {
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      print(user?.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    for (var node in [_emailFocus, _password, _passwordVerification]) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _password.dispose();
    _passwordVerification.dispose();
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
                      "SignUp",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(
                              MaterialPageRoute(
                                builder: (context) => Material(
                                  child: LoginForm(),
                                ),
                              ),
                            );
                          },
                          child: Text("Login"),
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

                    // Verify Password
                    Container(
                      decoration: shadow,
                      child: TextFormField(
                        focusNode: _passwordVerification,
                        controller: _passwordVerificationTextController,
                        obscureText: true,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 1,
                        decoration:
                            _passwordVerificationTextController.text.isNotEmpty
                            ? inputDecoration(
                                '',
                                _passwordVerification.hasFocus,
                              )
                            : inputDecoration(
                                'Verify Password',
                                _passwordVerification.hasFocus,
                              ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please validate your password.';
                          }

                          if (value != _passwordTextController.text) {
                            return 'Passwords must match!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                   
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
                        onPressed: () {
                          createUser(
                            _emailTextController.text,
                            _passwordTextController.text,
                          );
                        },
                        child: Text("Submit")
                      ),
                    ),

                    // sign up with google
                    // sign up with facebook 
                    // sign up with apple
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
