import 'package:flutter/material.dart';

class notificationScreen extends StatefulWidget {
  const notificationScreen({super.key});

  @override
  State<notificationScreen> createState() => notificationScreenState();
}

class notificationScreenState extends State<notificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Image.asset('assets/logo.png',height: 60,),
        titleSpacing: 10,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body:Center (
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
                   const SizedBox(height: 20),
                   Image.asset('assets/Group 34.png',height:90,),
                   Text('توجد حالة ازدحام في منطقة ',
                    style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          ),),
                   Text('3',style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          ),),
                   Text('  الرجاء التوجه لها الان ',style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          ),),
            ]
            )
      )
    );
  }
}