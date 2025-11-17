import 'package:cloud_firestore/cloud_firestore.dart';

class PostDocument {
  final String id;
  final String author; // user.id
  final String title;
  final String subtitle;
  final List<String> paragraphs;
  final List<String> assets;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  PostDocument({
    required this.id,
    required this.author,
    required this.title,
    required this.subtitle,
    required this.paragraphs,
    required this.assets,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory PostDocument.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return PostDocument(
      id: documentId,
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      paragraphs: List<String>.from(json['paragraphs'] ?? []),
      assets: List<String>.from(json['assets'] ?? []),
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
      dateUpdated: (json['dateUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'subtitle': subtitle,
      'paragraphs': paragraphs,
      'assets': assets,
      'dateCreated': Timestamp.fromDate(dateCreated),
      'dateUpdated': Timestamp.fromDate(dateUpdated),
    };
  }
}

class PostDocumentService {
  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');

  Future<PostDocument> createPost(PostDocument post) async {
    final data = {
      'author': post.author,
      'title': post.title,
      'subtitle': post.subtitle,
      'paragraphs': post.paragraphs,
      'assets': post.assets,
      'dateCreated': FieldValue.serverTimestamp(),
      'dateUpdated': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference docRef = await _postsRef.add(data);
      DocumentSnapshot snapshot = await docRef.get();

      final json = snapshot.data() as Map<String, dynamic>;
      return PostDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        docRef.id,
      );
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<PostDocument?> getPost(String id) async {
    try {
      DocumentSnapshot doc = await _postsRef.doc(id).get();
      if (!doc.exists) return null;

      final json = doc.data() as Map<String, dynamic>;
      return PostDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get post: $e');
    }
  }

  Future<List<PostDocument>> getAllPosts() async {
    try {
      QuerySnapshot snapshot = await _postsRef.get();

      return snapshot.docs.map((doc) {
        final json = doc.data() as Map<String, dynamic>;
        return PostDocument.fromJson(
          {
            ...json,
            'dateCreated': json['dateCreated'] ?? Timestamp.now(),
            'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
          },
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get posts: $e');
    }
  }

  Future<void> updatePost(PostDocument post) async {
    try {
      await _postsRef.doc(post.id).update({
        ...post.toJson(),
        'dateUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _postsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}