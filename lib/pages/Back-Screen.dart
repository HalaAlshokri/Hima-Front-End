import 'package:flutter/material.dart';
import '/pages/access-Screen.dart';

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
              onPressed : () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=> const accessScreen()),
                );
              },
              child: Text(
                "الرجوع",
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
            ])
       )
      );
  }
}
