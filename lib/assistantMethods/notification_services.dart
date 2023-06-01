
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices{

  FirebaseMessaging messaging=FirebaseMessaging.instance;

  void requestNotificationPermission() async
  {
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );

    if (settings.authorizationStatus==AuthorizationStatus.authorized)
    {
      print("User Granted Permission");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
    {
      print("User Granted Provisional Permission");
    }
    else{
      print("Permission declined");
    }
  }


}