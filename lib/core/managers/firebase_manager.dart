import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';

class FirebaseManager {
  static Future<String?> getFcmToken() async {
    final messaging = FirebaseMessaging.instance;
    String? fcmToken;
    await messaging.getToken().then((value) {
      fcmToken = value;
      logger.i('fcmToken=> $fcmToken');
    }).catchError((onError) {
      logger.e('Error fcmToken=> $onError');
      fcmToken = "";
    });
    return fcmToken;
  }
}
