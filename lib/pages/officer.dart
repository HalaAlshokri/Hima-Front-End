import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hima_front_end/pages/Messages.dart';
import 'package:hima_front_end/pages/signin_auth.dart';

class OfficerHomepage extends StatefulWidget {
  const OfficerHomepage({super.key});

  @override
  State<OfficerHomepage> createState() => OfficerHomepageState();
}

class OfficerHomepageState extends State<OfficerHomepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isNotify = false;

  int area = 1; //------------to assigned area not this //map conflict?
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
 /* Future<void> getMessage() async {
    //message method
    await Future.delayed(const Duration(seconds: 5), () {});
    setState(() {
      isNotify = true;
    });
  }*/

  @override
  /**/void initState() {
    super.initState();
    msgObject.requestPermission();
    msgObject.getToken();
    OffinitInfo();
    //handling to show the sign in screen
    //getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 60, //appbar height
        //padding method necessary to push logo to right
        title: Row(children: [
          Image.asset(
            'assets/images/Hima_logo.jpg',
            height: 45,
            width: 45,
          ),
          const SizedBox(
            width: 190,
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () async {
              await signOut();
            },
            backgroundColor: const Color.fromARGB(255, 99, 154, 125),
            child: const Icon(Icons.logout_outlined,
                size: 20, color: Colors.white),
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
    return noNotification();
  }

  Widget noNotification() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 120),
          Image.asset('assets/images/noassigned.png'),
          Padding(padding: EdgeInsets.only(top: 280.0)),
          TextButton(
            child: const Text(
              "إبلاغ عن المنطقة ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 14,
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
          Image.asset('assets/images/ringing.png'),
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
            height: 40,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(
                            area: area,
                          ))); //////////////////////fix to assigned area
            },
            color: const Color.fromARGB(255, 99, 154, 125),
            child: const Text(
              "    رؤية الخريطة     ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
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
      print("${event.notification!.body}");
      setState(() {
        isNotify = true;
        msg = ("${event.notification!.body}");
      });
      await flutterLocalNotificationsPlugin.show(
          0,
          "${event.notification!.title}",
          "${event.notification!.body}",
          notificationDetails);
    });
  }
    Future<void> support() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ادخل عدد الضباط المراد',
           textAlign: TextAlign.center, 
           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
           ),
          content: TextField(
            onChanged: (value) {
              desiredOfficerNum = value;
            },
            decoration: InputDecoration(hintText: '30', 
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child:
            TextButton(
              child: Text('إرسال',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
