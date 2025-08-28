import 'package:cloud_firestore/cloud_firestore.dart';

class Embadingrepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> uploadFaceEmbedding({
    required String username,
    required String name,
    required List<double> embedding,
  }) async {
    try {
      await _firestore
          .collection('attendify')
          .doc('UserData')
          .collection('faceEmbeddings')
          .doc(username)
          .set(
        {
          'userName': username.toString().trim(),
          'name': name.toString().trim().toLowerCase(),
          'embedding': embedding,
          'createdAt': FieldValue.serverTimestamp(),
          'embeddingSize': embedding.length,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<double>?> getFaceEmbedding(String userId) async {
    try {
      final doc = await _firestore
          .collection('attendify')
          .doc('UserData')
          .collection('faceEmbeddings')
          .doc(userId)
          .get();
      if (doc.exists) {
        return List<double>.from(doc.data()!['embedding'] as List);
      }
      return null;
    } catch (e) {
      print('Error fetching embedding: $e');
      return null;
    }
  }
}
