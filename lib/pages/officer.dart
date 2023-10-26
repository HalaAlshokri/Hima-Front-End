import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hima_front_end/pages/Back-Screen.dart';
import 'package:hima_front_end/pages/Messages.dart';
import 'package:hima_front_end/pages/map.dart';
import 'package:hima_front_end/pages/signin_auth.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

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

//to be deleted no need for it
  Future<void> reachLocation() async {
    if (isArrive) {
      _updateArea();
    }
  }

  void notificationTimer() {
    print('Timer expired');
    setState(() {
      isNotify = false;
      isArrive = true;
    });
    Fluttertoast.showToast(
      msg: "تاخرت انتهت 5 دقائق",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFFF3D758),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  void _updateArea() {
    /**update oLocation value for current user */
    User? user = FirebaseAuth.instance.currentUser;
    final _firestore = FirebaseFirestore.instance;
    _firestore
        .collection("users")
        .doc(user?.uid)
        .set({"oLocation": area}, SetOptions(merge: true));
    if (isNotify) {
      Fluttertoast.showToast(
        msg: "وصلت الى الوجهه المطلوبة",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 99, 154, 125),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      setState(() {
        isNotify = false;
        isArrive = true;
      });
    }
  }

  //--------------location------------------
  Position? _currentlocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  bool isDenied = false;

  Future<Position> _getCurrentLocation() async {
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
    return await Geolocator.getCurrentPosition();
  }

  static const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  StreamSubscription<Position>? positionStream;
  void _locationListener() {
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        setState(() {
          _currentlocation = position;
          isArrive = _testArea(
              LatLng(_currentlocation!.latitude, _currentlocation!.longitude),
              area);
        });
        print('new listener position is ' +
            (position.latitude.toString()) +
            ' and ' +
            (position.longitude.toString()));
      }
    });
  }

  //---------------test area-----------
  bool _testArea(LatLng currentPoint, int assigned) {
    List<LatLng> boundArea1 = [];
    //road in nimra mosque
    boundArea1.add(LatLng(21.3527671, 39.9639548));
    boundArea1.add(LatLng(21.3504605, 39.9678601));
    boundArea1.add(LatLng(21.3503943, 39.9677769));
    boundArea1.add(LatLng(21.352672, 39.963899));

    List<LatLng> boundArea2 = [];
    //other side road in nimra mosque
    boundArea2.add(LatLng(21.3552368, 39.9656999));
    boundArea2.add(LatLng(21.3529654, 39.9697091));
    boundArea2.add(LatLng(21.3528696, 39.9696565));
    boundArea2.add(LatLng(21.3551522, 39.9656030));

    List<LatLng> boundArea3 = [];
    //arafa mountain
    boundArea3.add(LatLng(21.3555936, 39.9822563));
    boundArea3.add(LatLng(21.3541446, 39.9853361));
    boundArea3.add(LatLng(21.3530196, 39.9844729));
    boundArea3.add(LatLng(21.3541681, 39.9815856));

    List<LatLng> boundArea4 = [];
    //arafa mountain
    boundArea4.add(LatLng(21.3564306, 39.9838213));
    boundArea4.add(LatLng(21.3549801, 39.9856491));
    boundArea4.add(LatLng(21.3541446, 39.9853361));
    boundArea4.add(LatLng(21.3555936, 39.9822563));

    bool contains1 =
        PolygonUtil.containsLocation(currentPoint, boundArea1, true);
    bool contains2 =
        PolygonUtil.containsLocation(currentPoint, boundArea2, true);
    bool contains3 =
        PolygonUtil.containsLocation(currentPoint, boundArea3, true);
    bool contains4 =
        PolygonUtil.containsLocation(currentPoint, boundArea4, true);
    if ((contains1 && assigned == 1) ||
        (contains2 && assigned == 2) ||
        (contains3 && assigned == 3) ||
        (contains4 && assigned == 4)) {
      return true;
    } else {
      return false;
    }
  }
  //---------------end test area-----------

  @override
  void initState() {
    super.initState();
    setState(() async {
      area = await getOfficerLocation();
    });
    msgObject.requestPermission();
    msgObject.getToken();
    OffinitInfo();
    _getCurrentLocation();
    _locationListener();
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }
    super.dispose;
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
          TextButton(
            child: const Text(
              "إبلاغ عن المنطقة ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: const Color.fromARGB(255, 99, 154, 125),
              ),
            ),
            onPressed: () {
              support();
            },
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
          const SizedBox(height: 60),
          Image.asset(
            'assets/images/ringing.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: Color.fromARGB(255, 99, 154, 125),
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
          reachLocation()
              .timeout(Duration(minutes: 5), onTimeout: notificationTimer);
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
