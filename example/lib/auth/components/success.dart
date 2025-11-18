import 'package:example/documents/user/UserDocumentService.dart';
import 'package:example/documents/user/components/createUser.dart';
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
    newUser();      // <-- RUN HERE ONCE
  }

  Future<void> newUser() async {
    try {
      var user = await UserDocumentService().getUserByEmail(
        widget.currentUser.email ?? "",
      );

      setState(() {
        newProfile = user == null;   // true = show CreateUser
        isLoading = false;
      });

    } on FirebaseException catch (e) {
      setState(() => isLoading = false);

      if (!context.mounted) return;
      _showErrorDialog(context, e.message ?? "Authentication failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('${widget.currentUser.email}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: OutlinedButton(
                        onPressed: logout,
                        child: const Text('Sign Out'),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: newProfile
                      ? CreateUser()      // <-- will now display properly
                      : const Text("Success"),
                ),
              ],
            ),
    );
  }
}


