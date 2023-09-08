import 'package:flutter/material.dart';

class noNotificationScreen extends StatefulWidget {
  const noNotificationScreen({super.key});

  @override
  State<noNotificationScreen> createState() => noNotificationScreenState();
}

class noNotificationScreenState extends State<noNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),

      appBar: AppBar(
          title: Image.asset('assets/logo.png', height: 60),
          titleSpacing: 10,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          toolbarHeight: 80,
          leading: null,
          automaticallyImplyLeading: false,

        ),


      body:Center (
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,

            children:[

                   SizedBox(height: 20),
                   Image.asset('assets/Group 27.png'),

            ])
      )
    );
  }
}