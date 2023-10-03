import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/signin_auth.dart';

class noNotificationScreen extends StatefulWidget {
  const noNotificationScreen({super.key});

  @override
  State<noNotificationScreen> createState() => noNotificationScreenState();
}

class noNotificationScreenState extends State<noNotificationScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout:
  signOut() async {
    await auth.signOut();
    await SessionManager().destroy();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Row(children: [
            Image.asset('assets/logo.png', height: 60),
            FloatingActionButton(
              onPressed: () {
                signOut();
              },
              child: Icon(Icons.logout_rounded),
              backgroundColor: Color.fromARGB(255, 99, 154, 125),
            ),
          ]),
          titleSpacing: 10,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          toolbarHeight: 80,
          leading: null,
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 20),
          Image.asset('assets/Group 27.png'),
        ])));
  }
}
