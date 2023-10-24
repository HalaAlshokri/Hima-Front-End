import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/Messages.dart';
import 'package:hima_front_end/pages/officerList.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hima_front_end/pages/signin_auth.dart';

import 'redistribution.dart';
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

class SupervisorHomepage extends StatefulWidget {
  const SupervisorHomepage({super.key});

  @override
  State<SupervisorHomepage> createState() => SupervisorState();
}

class SupervisorState extends State<SupervisorHomepage> {
  final List<String> area = ['1', '2', '3', '4'];
  List<int> totalOfficers = [50, 50, 50, 50];
  List<int> existOfficers = [0, 0, 0, 0];
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout:
  signOut() async {
    await SessionManager().destroy();
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  Future<void> numOfficerInArea() async {
    List<int> OfficerNum = [0, 0, 0, 0];
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      if (doc.data()['role'] == 'officer') {
        if (doc.data()['oLocation'] == 1) {
          OfficerNum[0]++;
        } else if (doc.data()['oLocation'] == 2) {
          OfficerNum[1]++;
        } else if (doc.data()['oLocation'] == 3) {
          OfficerNum[2]++;
        } else if (doc.data()['oLocation'] == 4) {
          OfficerNum[3]++;
        }
      }
    }
    for (int i = 0; i < OfficerNum.length; i++) {
      existOfficers[i] = OfficerNum[i];
    }
  }
  
  @override
  void initState() {
    Messages msgObj = Messages();
    msgObj.requestPermission();
    msgObj.getToken();
    msgObj.SupinitInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Whole page white background
      //extendBodyBehindAppBar: true, //Extend scaffold body to eliminate appbar
      //Appbar only contains Hima logo
      appBar: AppBar(
        toolbarHeight: 80, //appbar height was 60
        //padding method necessary to push logo to right
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/Hima_logo.jpg',
              height: 70, // was 45
              width: 70, // was 45
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 225,
          ),
          SizedBox(
            width: 55,
            height: 55,
            child: FloatingActionButton(
              mini: true,
              onPressed: () async {
                await signOut();
              },
              backgroundColor: const Color.fromARGB(255, 99, 154, 125),
              child: const Icon(Icons.logout_outlined,
                  size: 25, color: Colors.white), //Size was 20
            ),
          ),
        ]),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      //wrapped scaffold body with container to control alignment
      body: Container(
        height: 900, //was 600
        padding: const EdgeInsets.only(top: 10),
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            Image.asset(
              'assets/images/ring.png',
              height: 200, //was 84
              width: 200, //was 84
              fit: BoxFit.contain,
            ),

            //Container for areas feed buttons
            //Represents distribution green rectangle
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(6),
              child: SingleChildScrollView(
                //scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    const Text(
                      "لا يوجد زحام",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 99, 154, 125),
                      ),
                    ),
                    const SizedBox(
                        height:
                            15), //to space out components in green container (rectangle)
                    //row container for area word
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 99, 154, 125),
                                  width: 1.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6.0)),
                              color: const Color.fromARGB(255, 99, 154, 125),
                            ),
                            height: 36, // was 32
                            width: 90, // was 80
                            child: const Text(
                              "المنطقة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, // was 17
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    //container for every area and number of officers ber assigned officers in area
                    list(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            //Container for last row in body column (for new distribution button)
            Container(
              margin: const EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 40),
                  SizedBox(
                    height: 25,
                    width: 85,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Redistribution(
                                    zone1: 50,
                                    zone2: 50,
                                    zone3: 50,
                                    zone4: 50,
                                    isModel: false)));
                      }, //button action for redistribution page---------------------------------------------IMPORTANT
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('اضغط هنا',
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                // color of the shadow
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 2),
                              ),
                            ],
                            color: Color(0xff808080),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "تقسيم جديد؟",
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          // color of the shadow
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 99, 154, 125),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfficerList()));
                      },
                      backgroundColor: const Color.fromARGB(255, 99, 154, 125),
                      child: const Icon(Icons.people_rounded,
                          size: 25, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  //listview
  Widget list() {
    return FutureBuilder(
      future: numOfficerInArea(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SizedBox(
            //size of the outer box list
            height: 200, //was 200
            width: 320, //was 250
            //list view builder
            child: ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: area.length, //number of items
              itemBuilder: (BuildContext context, int index) {
                //container holds row information
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 200,
                  color: Colors.white,
                  //Row has different container boxes of information
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //first left container has the total number of officers in one area
                      Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 99, 154, 125),
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            color: const Color.fromARGB(255, 99, 154, 125),
                          ),
                          height: 36, // was 27
                          width: 45, // was 30
                          child: Text(
                            "${totalOfficers[index]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      //the word ضابط من  to clear the reading
                      Container(
                          color: Colors.white,
                          child: const Text(
                            "ضابط من",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, //was 15
                                color: Color.fromARGB(255, 99, 154, 125),
                                fontWeight: FontWeight.bold),
                          )),
                      // middle container to show the number of officer are in the area in the moment
                      Container(
                          margin: const EdgeInsets.all(10), //was 3
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 99, 154, 125),
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            color: const Color.fromARGB(255, 99, 154, 125),
                          ),
                          height: 36, // was 27
                          width: 45, // was 30
                          child: Text(
                            "${existOfficers[index]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      //the right container which show the area number
                      Container(
                          margin: const EdgeInsets.fromLTRB(3, 3, 8, 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 99, 154, 125),
                                width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            color: const Color.fromARGB(255, 99, 154, 125),
                          ),
                          height: 30, // was 27
                          width: 80,
                          child: Text(
                            "${area[index]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
  //----------------------------------------model listner--------------------------------------------------

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Start the timer to compare documents every 5 minutes
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _compareDocuments();
    });
  }

  void _compareDocuments() {
    final firestore = FirebaseFirestore.instance;
    final collectionReference = firestore.collection('redistribution');

    // Fetch the first document
    collectionReference.doc('current').get().then((snapshot1) {
      if (snapshot1.exists) {
        // Fetch the second document
        collectionReference.doc('official').get().then((snapshot2) {
          if (snapshot2.exists) {
            // Compare the documents
            final data1 = snapshot1.data();
            final data2 = snapshot2.data();

            // Perform your comparison logic here
            if (data1!['Zone-A'] != data2!['Zone-A']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Redistribution(
                          zone1: data1['Zone-A'],
                          zone2: data1['Zone-B'],
                          zone3: data1['Zone-C'],
                          zone4: data1['Zone-D'],
                          isModel: true)));
            } else if (data1['Zone-B'] != data2['Zone-B']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Redistribution(
                          zone1: data1['Zone-A'],
                          zone2: data1['Zone-B'],
                          zone3: data1['Zone-C'],
                          zone4: data1['Zone-D'],
                          isModel: true)));
            } else if (data1['Zone-C'] != data2['Zone-C']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Redistribution(
                          zone1: data1['Zone-A'],
                          zone2: data1['Zone-B'],
                          zone3: data1['Zone-C'],
                          zone4: data1['Zone-D'],
                          isModel: true)));
            } else if (data1['Zone-D'] != data2['Zone-D']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Redistribution(
                          zone1: data1['Zone-A'],
                          zone2: data1['Zone-B'],
                          zone3: data1['Zone-C'],
                          zone4: data1['Zone-D'],
                          isModel: true)));
            }

            // Print the result
            print('Comparison Result: $data1 vs $data2');
          } else {
            print('Document2 does not exist');
          }
        });
      } else {
        print('Document1 does not exist');
      }
    });
  }
  //----------------------------------------model listner--------------------------------------------------
}
