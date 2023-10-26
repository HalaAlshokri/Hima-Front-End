import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hima_front_end/pages/Messages.dart';
import 'package:hima_front_end/pages/officerList.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: Redistribution(
              zone1: 50, zone2: 50, zone3: 50, zone4: 50, isModel: false))));
}

//Source: https://stackoverflow.com/questions/53394135/convert-english-number-with-farsi-or-arabic-number-in-dart
String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '٧', '۸', '۹'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }
  return input;
}

class Redistribution extends StatefulWidget {
  final int zone1;
  final int zone2;
  final int zone3;
  final int zone4;
  final bool isModel;
  const Redistribution(
      {super.key,
      required this.zone1,
      required this.zone2,
      required this.zone3,
      required this.zone4,
      required this.isModel});

  @override
  State<Redistribution> createState() => RedistributionState();
}

class RedistributionState extends State<Redistribution> {
  //const RedistributionState({super.key});
  int initialValue = 25;
  //initial value of officer in each area

  List<int> cont = []; // = [50, 50, 50, 50];
  Color containerColor = const Color.fromARGB(255, 99, 154, 125);
  List<Color> areaContainerColor = [
    const Color.fromARGB(255, 99, 154, 125),
    const Color.fromARGB(255, 99, 154, 125),
    const Color.fromARGB(255, 99, 154, 125),
    const Color.fromARGB(255, 99, 154, 125)
  ];

  @override
  void initState() {
    super.initState();
    //handling to show the sign in screen
    cont.add(widget.zone1);
    cont.add(widget.zone2);
    cont.add(widget.zone3);
    cont.add(widget.zone4);
    if (widget.isModel) {
      setState(() {
        containerColor = const Color(0xFFF3D758);
      });
      int maxvalue = max(cont[0], cont[1]);
      maxvalue = max(maxvalue, cont[2]);
      maxvalue = max(maxvalue, cont[3]);
      print(maxvalue.toString());
      for (int i = 0; i < cont.length; i++) {
        if (cont[i] == maxvalue) {
          setState(() {
            areaContainerColor[i] = const Color(0xFFF3D758);
          });
        }
      }
    }
  }

  Messages msgObject = Messages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70, //appbar height
        //padding method necessary to push logo to right
        title: Image.asset(
          'assets/images/Hima_logo.jpg',
          height: 70, // was 45
          width: 70, // was 45
        ),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      //container for hole body
      body: Container(
        height: 800,
        //padding: const EdgeInsets.only(top: 10),
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            head(),
            //container for rows of info
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                  left: 10, top: 30, right: 0, bottom: 10),
              padding:
                  const EdgeInsets.only(left: 15, top: 20, right: 0, bottom: 0),
              width: 315.0,
              height: 276.0,
              //color: Color.fromARGB(255, 202, 223, 212),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 202, 223, 212),
                    width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: const Color.fromARGB(255, 202, 223, 212),
              ),
              //column represents inside contaainer
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //first row for illustration of content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //for officers number word
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(3, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: containerColor, width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0)),
                          color: containerColor,
                        ),
                        height: 27,
                        width: 168,
                        child: fixedTextStyle("عدد الضباط"),
                      ),
                      SizedBox(width: 21),
                      //the right container which show area word
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(3, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: containerColor, width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0)),
                          color: containerColor,
                        ),
                        height: 27,
                        width: 78,
                        child: fixedTextStyle("المنطقة"),
                      ),
                    ],
                  ),
                  //list to handle each row of area
                  list(),
                ],
              ),
            ),
            SizedBox(height: 20),
            //submuting button widget
            submitButton(),
          ],
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: GNav(
            selectedIndex: 1,
            onTabChange: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupervisorHomepage()));
              } else if (index == 2) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => OfficerList()));
              }
            },
            curve: Curves.easeInOut, // tab animation curves
            gap: 8, // the tab button gap between icon and text
            color: const Color.fromARGB(
                123, 255, 255, 255), // unselected icon color
            backgroundColor: const Color.fromARGB(255, 99, 154, 125),
            activeColor: Colors.white, // selected icon and text color
            iconSize: 27, // tab button icon size
            tabBackgroundColor: const Color.fromARGB(
                57, 255, 255, 255), // selected tab background color
            tabMargin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8), // navigation bar padding
            tabs: const <GButton>[
              GButton(
                icon: Icons.home,
                text: 'الرئيسية',
                textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              GButton(
                icon: Icons.group_add_rounded,
                text: 'تقسيم جديد',
                textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              GButton(
                icon: Icons.groups_2_rounded,
                text: 'قائمة الضباط',
                textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }

  //head style depend on if model or new distribution
  Widget head() {
    if (widget.isModel) {
      return Column(children: [
        Image.asset(
          'assets/images/ringing.png',
          height: 150, // was 84
          width: 150, // was 84
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        const Text(
          "توجد حالة ازدحام",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF3D758),
          ),
        ),
      ]);
    } else {
      return Container(
          margin:
              const EdgeInsets.only(left: 10, top: 80, right: 10, bottom: 0),
          //padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
          width: 310.0,
          height: 30.0,
          //color: Color.fromARGB(255, 202, 223, 212),
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 99, 154, 125), width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: const Color.fromARGB(255, 99, 154, 125),
          ),

          //column represents inside green contaainer
          child: Center(
            child: fixedTextStyle("تقسيم جديد للضباط"),
          ));
    }
  }

  //to hangle repeated text style
  Widget fixedTextStyle(String word) {
    return Text(
      word,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  //listview
  Widget list() {
    return SizedBox(
      //size of the outer box list
      height: 220,
      width: 309,
      //list view builder
      child: ListView.builder(
        //padding: const EdgeInsets.all(5),
        itemCount: 4, //number of items
        itemBuilder: (BuildContext context, int index) {
          //container holds row information
          return Container(
            alignment: Alignment.center,
            height: 50,
            width: 220,
            //Row has different container boxes of information
            child: Row(
              children: [
                //first left widget for decrement
                decrementButton(index),
                const SizedBox(width: 10),
                //the number of officer in each area
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 99, 154, 125),
                        width: 2.0),
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  height: 27,
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    cont[index].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 99, 154, 125),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                // middle widget for increment
                incrementButton(index),
                //the right container which show the area number
                Container(
                    margin: const EdgeInsets.fromLTRB(17, 3, 8, 3),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: areaContainerColor[index], width: 1.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0)),
                      color: areaContainerColor[index],
                    ),
                    height: 27,
                    width: 77,
                    child: Text(
                      "${++index}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15,
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

  //handling the increment button
  Widget incrementButton(int index) {
    index--;
    return MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        elevation: 5.0,
        height: 27,
        minWidth: 16,
        onPressed: () {
          index++;
          setState(() {
            cont[index]++;
            print('update cont index ' +
                index.toString() +
                " its " +
                cont[index].toString());
          });
        },
        color: areaContainerColor[index + 1],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ));
  }

  //handling the decrement button
  Widget decrementButton(int index) {
    index--;
    return MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0))),
        elevation: 5.0,
        height: 27,
        minWidth: 16, // was 16
        onPressed: () {
          index++;
          setState(() {
            cont[index]--;
            print('update cont index ' +
                index.toString() +
                " its " +
                cont[index].toString());
          });
        },
        color: areaContainerColor[index + 1],
        child: const Icon(
          Icons.horizontal_rule,
          color: Colors.white,
        ));
  }

  //handling the submit button
  Widget submitButton() {
    return MaterialButton(
        shape: CircleBorder(
            //borderRadius: BorderRadius.all(Radius.circular(100))
            side: BorderSide.none,
            eccentricity: 0.0),
        elevation: 5.0,
        height: 66,
        minWidth: 66,
        onPressed: () {
          findOfficer(cont[0], cont[1], cont[2], cont[3]);
          print('findOffecer');
        },
        color: const Color.fromARGB(255, 99, 154, 125),
        child: const Icon(
          Icons.check_sharp,
          color: Colors.white,
          size: 44,
        ));
  }

  //handling finding available officers and send messages
  Future<void> findOfficer(int A, int B, int C, int D) async {
    int requiredA = 0;
    int requiredB = 0;
    int requiredC = 0;
    int requiredD = 0;
    User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      final location = doc.data()['oLocation'];
      final status = doc.data()['oStatus'];
      final token = doc.data()['token'];
      if ((location == 2 || location == 3) &&
          status == "avaliable" &&
          requiredA != A) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 1');
        msgObject.sendNotification(
            "تعيين جديد", "تعيين جديد في منطقة 1", token);
        requiredA++;
        doc.reference.update({'oStatus': "busy"});
        continue;
      }
      if ((location == 1 || location == 3) &&
          status == "avaliable" &&
          requiredB != B) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 2');
        msgObject.sendNotification(
            "تعيين جديد", "تعيين جديد في منطقة 2", token);
        requiredB++;
        doc.reference.update({'oStatus': "busy"});
        continue;
      }
      if ((location == 2 || location == 4) &&
          status == "avaliable" &&
          requiredC != C) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 3');
        msgObject.sendNotification(
            "تعيين جديد", "تعيين جديد في منطقة 3", token);
        requiredC++;
        doc.reference.update({'oStatus': "busy"});
        continue;
      }
      if ((location == 2 || location == 3) &&
          status == "avaliable" &&
          requiredD != D) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 4');
        msgObject.sendNotification(
            "تعيين جديد", "تعيين جديد في منطقة 4", token);
        requiredD++;
        doc.reference.update({'oStatus': "busy"});
        continue;
      }
    }
    if (A != requiredA || B != requiredB || C != requiredC || D != requiredD) {
      Fluttertoast.showToast(
        msg:
            "عذرًا. لايتوفر عدد كافي من العناصر لهذا التقسيم، سيتم إشعار العناصر المتاحة فقط.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        textColor: Color.fromARGB(255, 99, 154, 125),
        fontSize: 15.0,
      );
    } else {
      Fluttertoast.showToast(
          msg: "تم الإرسال!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          textColor: Color.fromARGB(255, 99, 154, 125),
          fontSize: 15.0);
    }
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SupervisorHomepage()));
  }
}
