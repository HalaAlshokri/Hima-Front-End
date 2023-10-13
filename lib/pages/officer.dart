import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/signin_auth.dart';

class OfficerHomepage extends StatefulWidget {
  const OfficerHomepage({super.key});

  @override
  State<OfficerHomepage> createState() => OfficerHomepageState();
}

class OfficerHomepageState extends State<OfficerHomepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout:
  signOut() async {
    await SessionManager().destroy();
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  Future<void> getMessage() async {
    //message method
    await Future.delayed(const Duration(seconds: 3), () {});
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
      body: FutureBuilder(
        future: getMessage(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //snapshot.inState(ConnectionState.waiting);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 120),
                  Image.asset('assets/images/noassigned.png'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return notification();
          }
        },
      ),
    );
  }

  Widget notification() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image.asset('assets/images/ringing.png'),
          const SizedBox(height: 20),
          const Text(
            'تعيين جديد\nفي منطقة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: Color.fromARGB(255, 99, 154, 125),
            ),
          ),
          const Text(
            '1', ////////////////will change depend on the message
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 36,
              color: Color(0xFFF3D758),
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            elevation: 5.0,
            height: 40,
            onPressed: () {
              print('go to mappage');
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
}