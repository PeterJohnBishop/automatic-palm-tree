import 'package:example/auth/components/success.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class EntryView extends StatefulWidget {
  const EntryView({super.key});

  @override
  _EntryViewState createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        if (!snapshot.hasData) {
          return Center(
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
      child: LoginForm(),
    ),
  ),
  ),
);
        }

        final user = snapshot.data!;
        return SuccessView(currentUser: user);
      },
    );
  }
}
