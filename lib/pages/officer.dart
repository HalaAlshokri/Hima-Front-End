import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hima_front_end/pages/Back-Screen.dart';
import 'package:hima_front_end/pages/Messages.dart';
import 'package:hima_front_end/pages/map.dart';
import 'package:hima_front_end/pages/signin_auth.dart';

class OfficerHomepage extends StatefulWidget {
  const OfficerHomepage({super.key});

  @override
  State<OfficerHomepage> createState() => OfficerHomepageState();
}

class OfficerHomepageState extends State<OfficerHomepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isNotify = false;
  bool isArrive = true;

  int area = 1;
  String msg = "";
  String desiredOfficerNum = "";
  Messages msgObject = Messages();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //signout:
  signOut() async {
    await SessionManager().destroy();
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  //--------------location------------------
  late bool servicePermission = false;
  late LocationPermission permission;
  bool isDenied = false;

  Future<void> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      isDenied = true;
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        isDenied = true;
        return Future.error('Location permissions are denied');
      }
    }
    if (isDenied) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BackScreen()));
    }
    print('location accessed');
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      setarea();
    });
    msgObject.requestPermission();
    msgObject.getToken();
    OffinitInfo();
    _getCurrentLocation();
  }

  setarea() async {
    return await getOfficerLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 70, //appbar height
        //padding method necessary to push logo to right
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/Hima_logo.jpg',
              height: 70,
              width: 70,
            ),
          ),
          const SizedBox(
            width: 225,
          ),
          SizedBox(
            width: 55,
            height: 55,
            child: FloatingActionButton(
              mini: true,
              onPressed: () async {
                await signOut();
              },
              backgroundColor: const Color.fromARGB(255, 99, 154, 125),
              child: const Icon(Icons.logout_outlined,
                  size: 25, color: Colors.white),
            ),
          ),
        ]),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: screen(isNotify),
      ),
    );
  }

  Widget screen(bool isNotify) {
    if (isNotify) {
      return notification();
    }
    return noNotification(); //noNotification();-------------------------------------------------------------IMPORTANT
  }

  Widget noNotification() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 150),
          Image.asset('assets/images/noassigned.png'),
          Padding(padding: EdgeInsets.only(top: 240.0)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                backgroundColor: Color.fromARGB(255, 99, 154, 125),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)))),
            onPressed: () {
              support();
            },
            child: const Text(
              "إبلاغ عن المنطقة ",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notification() {
    Future.delayed(const Duration(seconds: 5), () {});
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 130),
          Image.asset(
            'assets/images/ringing.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color.fromARGB(255, 99, 154, 125),
              ),
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0))),
            elevation: 5.0,
            height: 50,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(
                            area: area,
                          )));
            },
            color: const Color.fromARGB(255, 99, 154, 125),
            child: const Text(
              "    رؤية الخريطة     ",
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> getOfficerLocation() async {
    int currentLocation;
    // Retrieve the current officer location
    String user = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    var userRef = db.collection("users");
    final doc = await userRef.doc(user).get();
    currentLocation = doc.data()?['oLocation'];
    return currentLocation;
  }

  Future<void> ReportArea(int num) async {
    int location = await getOfficerLocation();
    //get the appropriate supervisor
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      final supervisedAreas = doc.data()['supervisedAreas'];
      final token = doc.data()['token'];
      if (supervisedAreas != null && supervisedAreas.contains(location)) {
        msgObject.sendNotification(
            "إبلاغ منطقة مزدحمة",
            "المنطقة $location مزدحمة الآن. الرجاء إبلاغ $num من العناصر المتاحة.",
            token);
      }
    }
  }

  OffinitInfo() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max,
            priority: Priority.max,
            icon: "@mipmap/noty_icon");
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    // Firebase Message Recieving Code
    FirebaseMessaging.onMessage.listen((event) async {
      if (event.notification != null) {
        print("${event.notification!.body}");
        setState(() {
          isNotify = true;
          isArrive = false;
          msg = ("${event.notification!.body}");
          area = int.parse(msg.substring(msg.length - 1));
        });
        await flutterLocalNotificationsPlugin.show(
            0,
            "${event.notification!.title}",
            "${event.notification!.body}",
            notificationDetails);
      }
    });
  }

  Future<void> support() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ادخل عدد الضباط المراد',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal'),
          ),
          content: TextField(
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
            onChanged: (value) {
              desiredOfficerNum = value;
            },
            decoration: InputDecoration(
              hintText: '30',
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: Text('إرسال',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal')),
                onPressed: () async {
                  Navigator.of(context).pop();
                  ReportArea(int.parse(desiredOfficerNum));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
