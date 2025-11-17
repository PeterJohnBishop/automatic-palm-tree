import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> authenticateUser(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseException catch (e) {
      throw Exception('Login failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  Future<UserCredential> createUserAccount(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return credential;
    } on FirebaseException catch (e) {
      throw Exception('User creation failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during user creation: $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: "NO_USER",
          message: "No signed-in user",
        );
      }
      await user.verifyBeforeUpdateEmail(newEmail);
      await user.reload();
    } on FirebaseException catch (e) {
      throw Exception('Email Update failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during email update: $e');
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: "NO_USER",
          message: "No signed-in user",
        );
      }
      if (!user.emailVerified) await user.sendEmailVerification();
    } on FirebaseException catch (e) {
      throw Exception('Sending email verification failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during email verification: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      throw Exception('Password reset failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during password reset: $e');
    }
  }

  Future<void> setAvatar(String photoURL) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: "NO_USER",
          message: "No signed-in user",
        );
      }
      await user.updatePhotoURL(photoURL);
      await user.reload();
    } on FirebaseException catch (e) {
      throw Exception('Updating avatar failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during avatar update: $e');
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: "NO_USER",
          message: "No signed-in user",
        );
      }
      await user.delete();
   } on FirebaseException catch (e) {
      throw Exception('User account deletion failed: ${e.code} ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during user account deletion: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
