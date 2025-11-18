import 'package:cloud_firestore/cloud_firestore.dart';

class UserDocument {
  final String id; // <-- Firestore document ID
  final String image;
  final String name;
  final String email;
  final String phone;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zip;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  UserDocument({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.zip,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json, String documentId) {
    return UserDocument(
      id: documentId,
      image: json['image'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address1: json['address1'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
      dateUpdated: (json['dateUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "email": email,
    "phone": phone,
    "address1": address1,
    "address2": address2,
    "city": city,
    "state": state,
    "zip": zip,
    'dateCreated': Timestamp.fromDate(dateCreated),
    'dateUpdated': Timestamp.fromDate(dateUpdated),
  };
}

class UserDocumentService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  Future<UserDocument> createUserDocument(UserDocument user) async {
    final data = {
      'name': user.name,
      'image': user.image,
      'email': user.email,
      'phone': user.phone,
      'address1': user.address1,
      'address2': user.address2,
      'city': user.city,
      'state': user.state,
      'zip': user.zip,
      'dateCreated': FieldValue.serverTimestamp(),
      'dateUpdated': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference docRef = await _usersRef.add(data);
      DocumentSnapshot snapshot = await docRef.get();

      final json = snapshot.data() as Map<String, dynamic>;
      return UserDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        docRef.id,
      );
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserDocument?> getUser(String id) async {
    try {
      DocumentSnapshot doc = await _usersRef.doc(id).get();
      if (!doc.exists) return null;

      final json = doc.data() as Map<String, dynamic>;
      return UserDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<UserDocument?> getUserByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _usersRef
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final json = doc.data() as Map<String, dynamic>;

      return UserDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  Future<List<UserDocument>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersRef.get();

      return snapshot.docs.map((doc) {
        final json = doc.data() as Map<String, dynamic>;
        return UserDocument.fromJson(
          {
            ...json,
            'dateCreated': json['dateCreated'] ?? Timestamp.now(),
            'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
          },
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  Future<void> updateUser(UserDocument user) async {
    try {
      await _usersRef.doc(user.id).update({
        ...user.toJson(),
        'dateUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _usersRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}