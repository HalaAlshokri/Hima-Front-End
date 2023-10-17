import 'package:flutter/material.dart';

class backScreen extends StatefulWidget {
  const backScreen({super.key});

  @override
  State<backScreen> createState() => backScreenState();
}

class backScreenState extends State<backScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Image.asset(
          'assets/images/Hima_logo.jpg',
          height: 45,
          width: 45,
        ),
        titleSpacing: 10,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const Column(
          children: [
            SizedBox(height: 30),
            Icon(Icons.location_pin, size: 100, color: Color(0xFFF3D758)),
            SizedBox(height: 5),
            Text(
              'الرجاء السماح\n بتعقب موقع الجهاز',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Color.fromARGB(255, 99, 154, 125),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'السماح بتعقب الموقع يزيد من سهولة\n التوصل لحل سريع ومناسب ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
                color: Color.fromARGB(255, 99, 154, 125),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const noNotificationScreen()),
  );*/
