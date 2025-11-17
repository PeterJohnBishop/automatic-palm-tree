import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDocument {
  final String id;
  final String to; // user.id or post.id
  final String from; // user.id
  final String comment;
  final List<String> assets;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  CommentDocument({
    required this.id,
    required this.to,
    required this.from,
    required this.comment,
    required this.assets,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory CommentDocument.fromJson(
      Map<String, dynamic> json, String documentId) {
    return CommentDocument(
      id: documentId,
      to: json['to'] ?? '',
      from: json['from'] ?? '',
      comment: json['comment'] ?? '',
      assets: List<String>.from(json['assets'] ?? []),
      dateCreated: (json['dateCreated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dateUpdated: (json['dateUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'from': from,
      'comment': comment,
      'assets': assets,
      'dateCreated': Timestamp.fromDate(dateCreated),
      'dateUpdated': Timestamp.fromDate(dateUpdated),
    };
  }
}

class CommentDocumentService {
  final CollectionReference _commentsRef =
      FirebaseFirestore.instance.collection('comments');

  Future<CommentDocument> createComment(CommentDocument comment) async {
    final data = {
      'to': comment.to,
      'from': comment.from,
      'comment': comment.comment,
      'assets': comment.assets,
      'dateCreated': FieldValue.serverTimestamp(),
      'dateUpdated': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference docRef = await _commentsRef.add(data);
      DocumentSnapshot snapshot = await docRef.get();

      final json = snapshot.data() as Map<String, dynamic>;
      return CommentDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        docRef.id,
      );
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<CommentDocument?> getComment(String id) async {
    try {
      DocumentSnapshot doc = await _commentsRef.doc(id).get();
      if (!doc.exists) return null;

      final json = doc.data() as Map<String, dynamic>;
      return CommentDocument.fromJson(
        {
          ...json,
          'dateCreated': json['dateCreated'] ?? Timestamp.now(),
          'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
        },
        doc.id,
      );
    } catch (e) {
      throw Exception('Failed to get comment: $e');
    }
  }

  Future<List<CommentDocument>> getAllComments() async {
    try {
      QuerySnapshot snapshot = await _commentsRef.get();

      return snapshot.docs.map((doc) {
        final json = doc.data() as Map<String, dynamic>;
        return CommentDocument.fromJson(
          {
            ...json,
            'dateCreated': json['dateCreated'] ?? Timestamp.now(),
            'dateUpdated': json['dateUpdated'] ?? Timestamp.now(),
          },
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  Future<void> updateComment(CommentDocument comment) async {
    try {
      await _commentsRef.doc(comment.id).update({
        ...comment.toJson(),
        'dateUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  Future<void> deleteComment(String id) async {
    try {
      await _commentsRef.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
}