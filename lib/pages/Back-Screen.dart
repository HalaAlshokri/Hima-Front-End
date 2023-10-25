import 'package:flutter/material.dart';

class BackScreen extends StatefulWidget {
  const BackScreen({super.key});

  @override
  State<BackScreen> createState() => BackScreenState();
}

class BackScreenState extends State<BackScreen> {
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
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.location_pin, size: 100, color: Color(0xFFF3D758)),
            const SizedBox(height: 5),
            const Text(
              'الرجاء السماح\n بتعقب موقع الجهاز',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Color.fromARGB(255, 99, 154, 125),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              elevation: 5.0,
              height: 40,
              onPressed: () {},
              color: const Color.fromARGB(255, 99, 154, 125),
              child: const Text(
                "    اضغط للسماح بالوصول    ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
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
