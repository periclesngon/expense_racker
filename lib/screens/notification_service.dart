import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize FCM
  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle notifications when app is in foreground
      if (message.notification != null) {
        print('Notification received: ${message.notification!.title}');
      }
    });
  }

  // Request permission for notifications
  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  // Send notifications based on expenses or inactivity
  Future<void> sendExpenseNotification(String message) async {
    await _firebaseMessaging.subscribeToTopic('expenses');
    // Logic to send notification (on server-side using FCM API)
  }
}
