import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebase{

  //final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /*saveDeviceToken() async{
    String userId = 'omar';
    User user = await FirebaseAuth.instance.currentUser!;
    String? fcmToken = await _fcm.getToken();

    if(fcmToken != null){
      var tokenRef= _db.collection('users').doc(user.uid).collection('tokens').doc(fcmToken);
      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

  }*/

  getToken() async{
    String? fcmToken = await _fcm.getToken();
    print(fcmToken);
    if(fcmToken != null){
      return fcmToken;
    }else{
      return " ";
    }
  }

  Future<bool> callOnFcmApiSendPushNotifications(
      Future<String> userToken, Message message) async {

    print(message.text);
    print(userToken);
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "notification": {"body": message, "title": "New Notification"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$userToken"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=Server key'
    };

    print('hit till response');

    final response = await Dio().post(postUrl, data: data, options: Options(headers: headers));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

}
