import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Log user activity (e.g., deposit, add expense)
  Future<void> logUserActivity(String activityType, double amount) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestore.collection('user_activities').add({
        'uid': user.uid,
        'email': user.email,
        'activityType': activityType,
        'amount': amount,
        'timestamp': Timestamp.now(),
      });
    }
  }
}
