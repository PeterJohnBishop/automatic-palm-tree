import 'package:cloud_firestore/cloud_firestore.dart';

class UserDocument {
  final String id; // <-- Firestore document ID
  final String name;
  final String email;
  final String phone;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zip;

  UserDocument({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "address1": address1,
    "address2": address2,
    "city": city,
    "state": state,
    "zip": zip,
  };
}

class UserDocumentService {
  final CollectionReference _usersRef = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<UserDocument> createUserDocument(UserDocument user) async {
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
      DocumentReference docRef = await _usersRef.add(data);
      DocumentSnapshot snapshot = await docRef.get();
      return UserDocument.fromJson({
        "id": docRef.id,
        ...snapshot.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserDocument?> getUser(String id) async {
    try {
      DocumentSnapshot docRef = await _usersRef.doc(id).get();
      if (!docRef.exists) return null;
      return UserDocument.fromJson({
        "id": docRef.id,
        ...docRef.data() as Map<String, dynamic>,
      });
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<List<UserDocument>> getAllUsers() async {
    try {
      final snapshot = await _usersRef.get();

      return snapshot.docs.map((doc) {
        return UserDocument.fromJson({
          "id": doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  Future<void> updateUser(UserDocument user) async {
    try {
      await _usersRef.doc(user.id).update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String id) {
    try {
      return _usersRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
