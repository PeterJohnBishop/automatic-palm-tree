import 'package:example/storage/components/upload.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SuccessView extends StatefulWidget {
  final User currentUser;

  const SuccessView({super.key, required this.currentUser});

  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Text('${widget.currentUser.email}'),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: OutlinedButton(
                  onPressed: logout,
                  child: const Text('Sign Out'),
                ),
              ),
            ],
          ),

          Expanded(
            child: FileUpload(), 
          ),
        ],
      ),
    );
  }
}
