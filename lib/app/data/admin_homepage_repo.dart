import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomepageRepo {
  FirebaseFirestore _adminFirestore = FirebaseFirestore.instance;

  Future<void> addUser(String userName, String name, String password) async {
    await _adminFirestore
        .collection('attendify')
        .doc('UserData')
        .collection('userCradentials')
        .doc(userName)
        .set({
      'userName': userName.toString().trim(),
      'name': name.toString().trim(),
      'password': password.toString().trim(),
    });
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    final doc = await _adminFirestore
        .collection('attendify')
        .doc('UserData')
        .collection('users')
        .doc(userId)
        .get();
    return doc.data();
  }

  Future<void> updateUser(String userId, String userName) async {
    await _adminFirestore
        .collection('attendify')
        .doc('UserData')
        .collection('users')
        .doc(userId)
        .update({
      'userName': userName,
    });
  }

  Future<void> deleteUser(String userId) async {
    await _adminFirestore
        .collection('attendify')
        .doc('UserData')
        .collection('users')
        .doc(userId)
        .delete();
  }
}
