// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '/pages/Back-Screen.dart';
import '/pages/nonotification-Screen.dart';

main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
          textDirection: TextDirection.rtl, child: accessScreen())));
}

class accessScreen extends StatefulWidget {
  const accessScreen({super.key});

  @override
  State<accessScreen> createState() => accessScreenState();
}

class accessScreenState extends State<accessScreen> {
  void navigateNextPage() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/logo.png', height: 60),
          titleSpacing: 10,
          backgroundColor: Color.fromARGB(255, 8, 107, 86),
          elevation: 0,
          toolbarHeight: 80,
          leading: null,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Color.fromARGB(255, 8, 107, 86),
        body: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'تتبع موقع الجهاز',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            SizedBox(height: 45),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const backScreen()),
                );
              },
              child: Text(
                "الوصول",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 99, 153, 114)),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(80, 10, 80, 10),
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const noNotificationScreen()),
                );
              },
              child: Text(
                "عدم الوصول",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 8, 107, 86)),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 255, 255, 255)),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(80, 10, 80, 10),
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
            ),
          ]),
        ));
  }
}
