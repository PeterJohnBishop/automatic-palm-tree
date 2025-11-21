import 'package:cloud_firestore/cloud_firestore.dart';

class ListingDocument {
  final String id;
  final String agent; // user.id
  final String address1;
  final String address2;
  final double price;
  final String status;
  final double beds;
  final double baths;
  final double sqft;
  final List<String> liked;
  final List<String> loved;
  final List<String> comments;
  final String description;
  final String cover;
  final List<String> assets;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  ListingDocument({
    required this.id,
    required this.agent,
    required this.address1,
    required this.address2,
    required this.price,
    required this.status,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.liked,
    required this.loved,
    required this.comments,
    required this.description,
    required this.cover,
    required this.assets,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory ListingDocument.fromJson(
      Map<String, dynamic> json, String documentId) {
    return ListingDocument(
      id: documentId,
      agent: json['agent'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      beds: (json['beds'] ?? 0).toDouble(),
      baths: (json['baths'] ?? 0).toDouble(),
      sqft: (json['sqft'] ?? 0).toDouble(),
      liked: List<String>.from(json['liked'] ?? []),
      loved: List<String>.from(json['loved'] ?? []),
      comments: List<String>.from(json['comments'] ?? []),
      description: json['description'] ?? '',
      cover: json['cover'] ?? '',
      assets: List<String>.from(json['assets'] ?? []),
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
      dateUpdated: (json['dateUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'agent': agent,
      'address1': address1,
      'address2': address2,
      'price': price,
      'status': status,
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'liked': liked,
      'loved': loved,
      'comments': comments,
      'description': description,
      'cover': cover,
      'assets': assets,
      'dateCreated': Timestamp.fromDate(dateCreated),
      'dateUpdated': Timestamp.fromDate(dateUpdated),
    };
  }
}

class ListingDocumentService {
  final CollectionReference _listingsRef =
      FirebaseFirestore.instance.collection('listings');

  Future<ListingDocument> createListing(ListingDocument listing) async {
    final data = {
      'agent': listing.agent,
      'address1': listing.address1,
      'address2': listing.address2,
      'price': listing.price,
      'status': listing.status,
      'beds': listing.beds,
      'baths': listing.baths,
      'sqft': listing.sqft,
      'liked': listing.liked,
      'loved': listing.loved,
      'comments': listing.comments,
      'description': listing.description,
      'cover': listing.cover,
      'assets': listing.assets,
      'dateCreated': FieldValue.serverTimestamp(),
      'dateUpdated': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference docRef = await _listingsRef.add(data);
      DocumentSnapshot snapshot = await docRef.get();

      final json = snapshot.data() as Map<String, dynamic>;
      return ListingDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        docRef.id,
      );
    } catch (e) {
      throw Exception('Failed to create listing: $e');
    }
  }

  Future<ListingDocument?> getListing(String id) async {
    try {
      DocumentSnapshot doc = await _listingsRef.doc(id).get();
      if (!doc.exists) return null;

      final json = doc.data() as Map<String, dynamic>;
      return ListingDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get listing: $e');
    }
  }

  Future<List<ListingDocument>> getAllListings() async {
    try {
      QuerySnapshot snapshot = await _listingsRef.get();

      return snapshot.docs.map((doc) {
        final json = doc.data() as Map<String, dynamic>;
        return ListingDocument.fromJson(
          {
            ...json,
            'dateCreated': json['dateCreated'] ?? Timestamp.now(),
            'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
          },
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get listings: $e');
    }
  }

  Future<void> updateListing(ListingDocument listing) async {
    try {
      await _listingsRef.doc(listing.id).update({
        ...listing.toJson(),
        'dateUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update listing: $e');
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      await _listingsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete listing: $e');
    }
  }
}