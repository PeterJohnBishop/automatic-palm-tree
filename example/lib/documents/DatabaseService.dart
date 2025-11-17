import 'package:cloud_firestore/cloud_firestore.dart';
import 'userDocuments.dart';

class UserDocumentService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<UserDocument> createUserDocument(UserDocument user) async {
    final data = {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'address1': user.address1,
      'address2': user.address2,
      'city': user.city,
      'state': user.state,
      'zip': user.zip,
    };

    try {
      DocumentReference docRef = await _db.collection("users").add(data);
      DocumentSnapshot snapshot = await docRef.get();
      return UserDocument.fromJson({
        "id": docRef.id,
        ...snapshot.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }
}
