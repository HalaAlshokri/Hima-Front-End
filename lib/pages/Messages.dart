import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Messages {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print(".....................granted.....................");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("...................provisional...................");
    } else {
      print("......................failed......................");
    }
  }

  getToken() async {
  String? newToken = await FirebaseMessaging.instance.getToken();
  String? currentToken = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((doc) => doc.get('token'));
  if (newToken != currentToken) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': newToken}, SetOptions(merge: true));
  }
}

  SupinitInfo() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max,
            priority: Priority.max,
            icon: "@mipmap/noty_icon");
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    // Firebase Message Recieving Code
    FirebaseMessaging.onMessage.listen((event) async {
      print("${event.notification!.body}");
      await flutterLocalNotificationsPlugin.show(
          0,
          "${event.notification!.title}",
          "${event.notification!.body}",
          notificationDetails);
    });
  }

  sendNotification(String title, body, token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAlEjlq4w:APA91bFV1Fhmu5n-CJAJtvlA6y9g0iuAozfpK2i43ZQQw3vOgiyuFR1c3CQBswV1Nb2vB9jg1OWpp344RSv3cmiKwLQybFQxHzAJ9F26mBzHSDBAr1zX0RN_meR_i7uSgOkBFIr6fMms",
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            "to": token,
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "channel_id",
              "icon": "@mipmap/noty_icon",
            },
            "data": <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            }
          },
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}