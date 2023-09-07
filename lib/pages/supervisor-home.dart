import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//Firebase
/*import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';*/

/*await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);*/

main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
          textDirection: TextDirection.rtl, child: SupervisorHomepage())));
}

class SupervisorHomepage extends StatelessWidget {
  const SupervisorHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Whole page white background
      //extendBodyBehindAppBar: true, //Extend scaffold body to eliminate appbar
      //Appbar only contains Hima logo
      appBar: AppBar(
        toolbarHeight: 100, //appbar height
        //padding method necessary to push logo to right
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            //imported hima logo from assets folder
            'assets/images/Hima_logo.png',
            scale: 8, //scaled down due to big size
          ),
        ),
        backgroundColor: Colors.transparent, //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      //wrapped scaffold body with container to control alignment
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            //Crowd alarm stack
            Stack(
                alignment: Alignment.center, //to alighn stack elements
                children: [
                  //Container represents the empty circle with green borders
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Color(0xFF346957),
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  //Represents loading circle (the loading spinner)
                  SpinKitFadingCircle(
                    color: Color(0xFF346957),
                    size: 210,
                  ),
                  Image.asset(
                    'assets/images/notification off.png',
                    scale: 8,
                    color: Color(0xFF346957),
                  )
                ]),
            //Container for areas feed buttons
            //Represents distribution green rectangle
            Container(
                margin: EdgeInsets.only(top: 30),
                padding:
                    EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
                width: 360.0,
                height: 420.0,
                decoration: BoxDecoration(
                  color: Color(0xFF346957),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SingleChildScrollView(
                    //scrollDirection: Axis.horizontal,
                    child: Column(
                  children: [
                    Text(
                      "المناطق وعدد الضباط الموجودين فيها",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            // color of the shadow
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height:
                            15), //to space out components in green container (rectangle)
                    //Area 1 container for data feed
                    Container(
                        height: 50,
                        width: 310,
                        decoration: BoxDecoration(
                          color: Color(0xFF7ba49a),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        //using  a Row layout inside container
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 25,
                              child: TextField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "50",
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(3),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.5),
                                      borderSide: BorderSide(
                                        color: Color(0xFF346957),
                                        width: 2,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'ضابط من',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 30,
                              height: 25,
                              child: TextField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "50",
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(3),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.5),
                                      borderSide: BorderSide(
                                        color: Color(0xFF346957),
                                        width: 2,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'منطقة 1 يوجد فيها',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 15),
                    Container(
                        height: 50,
                        width: 310,
                        decoration: BoxDecoration(
                          color: Color(0xFF7ba49a),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        //using  a Row layout inside container
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 25,
                              child: TextField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "50",
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(3),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.5),
                                      borderSide: BorderSide(
                                        color: Color(0xFF346957),
                                        width: 2,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'ضابط من',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 30,
                              height: 25,
                              child: TextField(
                                enabled: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "30",
                                  hintStyle: TextStyle(color: Colors.black),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(3),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.5),
                                      borderSide: BorderSide(
                                        color: Color(0xFF346957),
                                        width: 2,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'منطقة 2 يوجد فيها',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      width: 310,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ba49a),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ],
                ))),
            //Container for last row in body column (for new distribution button)
            Container(
              margin: EdgeInsets.only(top: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 39,
                    width: 90,
                    child: TextButton(
                      onPressed:
                          () {}, //button action for distribution page---------------------------------------------IMPORTANT
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: Text('اضغط هنا',
                          style: TextStyle(
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  // color of the shadow
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: Color(0xFF346957),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("تقسيم جديد؟",
                      style: TextStyle(shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          // color of the shadow
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 2),
                        ),
                      ], fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//------------------------------Crowd alarm stateful widget------------------------------
class CrowdAlarm extends StatefulWidget {
  const CrowdAlarm({super.key});

  @override
  State<CrowdAlarm> createState() => _CrowdAlarm();
}

class _CrowdAlarm extends State<CrowdAlarm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  //final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('Supervisors').snapshots;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
