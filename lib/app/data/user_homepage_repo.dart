import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/calendar_utils.dart';

class UserHomepageRepo {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future addTodayAttendance(int year, String month, String todayDate,
      String userId, String session, dynamic data) async {
    await _firebaseFirestore
        .collection('attendify')
        .doc('Attandance')
        .collection(year.toString().trim())
        .doc(month.toString().trim())
        .collection(todayDate.toString().trim())
        .doc('userAttandance')
        .collection(userId.toString().trim())
        .doc(session.toString().trim())
        .set(data, SetOptions(merge: true));
    // Implementation for adding today's attendance
  }

  Future addTodayRecentActivity(
      dynamic data, String userId, String session) async {
    // await _firebaseFirestore
    //     .collection('attendify')
    //     .doc('recentActivity')
    //     .collection(
    //         "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}")
    //     .doc("${userId.toString().trim()}_${session.toString().trim()}")
    //     .set(data, SetOptions(merge: true));
    await _firebaseFirestore
        .collection('attendify')
        .doc('recentActivity')
        .collection('userActivities')
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(data, SetOptions(merge: true));
  }
}
