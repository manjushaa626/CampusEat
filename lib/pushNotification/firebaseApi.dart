import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Notification Title : ${message.notification?.title}');
  print('Notification Body : ${message.notification?.body}');

  // message data if it exits
  print('Payload : ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    // to handle the background stuff happening in the app when recieving the Notification
    FirebaseMessaging.onBackgroundMessage((handleBackgroundMessage));
  }
}
