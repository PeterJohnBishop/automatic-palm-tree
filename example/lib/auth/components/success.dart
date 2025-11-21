import 'package:example/documents/user/UserDocumentService.dart';
import 'package:example/documents/user/components/createUser.dart';
import 'package:example/documents/user/components/presentUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SuccessView extends StatefulWidget {
  final User currentUser;

  const SuccessView({super.key, required this.currentUser});

  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
  bool isLoading = true;
  bool newProfile = true;
  late UserDocument userDocument;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Loading Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    newUser(); // <-- RUN HERE ONCE
  }

  Future<void> newUser() async {
    try {
      var existingUser = await UserDocumentService().getUserByEmail(
        widget.currentUser.email ?? "",
      );
      if (existingUser != null) {
        setState(() {
          newProfile = false;
          isLoading = false;
          userDocument = existingUser;
        });
      } else {
        setState(() {
          newProfile = true;
          isLoading = false;
        });
      }
    } on FirebaseException catch (e) {
      setState(() => isLoading = false);
      if (!context.mounted) return;
      _showErrorDialog(context, e.message ?? "Authentication failed.");
    }
  }

  void userLoaded(UserDocument userLoaded) {
    try {
      setState(() {
        userDocument = userLoaded;
        newProfile = false;
        isLoading = false;
      });
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        newProfile ? 
                        SizedBox()
                        : PresentUser(userDocument: userDocument, size: 33),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: OutlinedButton(
                            onPressed: logout,
                            child: const Text('Sign Out'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: newProfile
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(25),
                            child: SizedBox(
                              width: 400, // <-- FIXED SIZE for debugging
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // needed for shadow visibility
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
                                child: ClipRRect(
                                  // keeps nice rounded content
                                  borderRadius: BorderRadius.circular(16),
                                  child: CreateUser(onUserCreated: userLoaded),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ),
              ],
            ),
    );
  }
}
