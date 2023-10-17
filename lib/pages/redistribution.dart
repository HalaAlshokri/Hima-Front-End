import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
          textDirection: TextDirection.rtl, child: Redistribution())));
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
  const Redistribution({super.key});

  @override
  State<Redistribution> createState() => RedistributionState();
}

class RedistributionState extends State<Redistribution> {
  //const RedistributionState({super.key});
  int initialValue = 50;
  //initial value of officer in each area
  List<int> cont = [50, 50, 50, 50];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60, //appbar height
        //padding method necessary to push logo to right
        title: Image.asset(
          'assets/images/Hima_logo.jpg',
          height: 45,
          width: 45,
        ),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      //container for hole body
      body: Container(
        height: 600,
        padding: const EdgeInsets.only(top: 10),
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            Image.asset(
              'assets/images/ring.png',
              height: 84,
              width: 84,
            ),
            const SizedBox(height: 10),
            const Text(
              "توزيع جديد",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 99, 154, 125),
              ),
            ),
            //container for rows of info
            Container(
              margin: const EdgeInsets.only(
                  left: 10, top: 30, right: 10, bottom: 10),
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20, bottom: 0),
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
                children: [
                  //first row for illustration of content
                  Row(
                    children: [
                      //for officers number word
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(3, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 99, 154, 125),
                              width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0)),
                          color: const Color.fromARGB(255, 99, 154, 125),
                        ),
                        height: 27,
                        width: 168,
                        child: fixedTextStyle("عدد الضباط"),
                      ),
                      //the right container which show area word
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(3, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 99, 154, 125),
                              width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0)),
                          color: const Color.fromARGB(255, 99, 154, 125),
                        ),
                        height: 27,
                        width: 80,
                        child: fixedTextStyle("المنطقة"),
                      ),
                    ],
                  ),
                  //list to handle each row of area
                  list(),
                ],
              ),
            ),
            //submuting button widget
            submitButton(),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.all(5),
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
                          color: const Color.fromARGB(255, 99, 154, 125),
                          width: 1.0),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0)),
                      color: const Color.fromARGB(255, 99, 154, 125),
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
        color: const Color.fromARGB(255, 99, 154, 125),
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
        minWidth: 16,
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
        color: const Color.fromARGB(255, 99, 154, 125),
        child: const Icon(
          Icons.horizontal_rule,
          color: Colors.white,
        ));
  }

  //handling the submit button
  Widget submitButton() {
    return MaterialButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(70.0))),
        elevation: 5.0,
        height: 66,
        minWidth: 55,
        onPressed: () {
          findOfficer(cont[0], cont[1], cont[2], cont[3]);
          print('findOffecer');
        },
        color: const Color.fromARGB(255, 99, 154, 125),
        child: const Icon(
          Icons.check_sharp,
          color: Color(0xFFF3D758),
          size: 44,
        ));
  }

  //handling finding available officers and send messages
  Future<void> findOfficer(int A, int B, int C, int D) async {
    int requiredA = 0;
    int requiredB = 0;
    int requiredC = 0;
    int requiredD = 0;
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      final location = doc.data()['oLocation'];
      final status = doc.data()['oStatus'];
      final token = doc.data()['token'];
      if ((location == 2 || location == 3) &&
          status == "Avaliable" &&
          requiredA != A) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 1');
        //put the calling for the notify message here//
        requiredA++;
        doc.reference.update({'oStatus': "Busy"});
        continue;
      }
      if ((location == 1 || location == 3) &&
          status == "Avaliable" &&
          requiredB != B) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 2');
        //put the calling for the notify message here//
        requiredB++;
        doc.reference.update({'oStatus': "Busy"});
        continue;
      }
      if ((location == 2 || location == 4) &&
          status == "Avaliable" &&
          requiredC != C) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 3');
        //put the calling for the notify message here//
        requiredC++;
        doc.reference.update({'oStatus': "Busy"});
        continue;
      }
      if ((location == 2 || location == 3) &&
          status == "Avaliable" &&
          requiredD != D) {
        print(
            'assign officer with the ID: ${doc.id}, and token: $token to area 4');
        //put the calling for the notify message here//
        requiredD++;
        doc.reference.update({'oStatus': "Busy"});
        continue;
      }
    }
    if (A != requiredA || B != requiredB || C != requiredC || D != requiredD) {
      Fluttertoast.showToast(
        msg:
            "عذرًا. لايتوفر عدد كافي من العناصر لهذا التقسيم، سيتم إشعار العناصر المتاحة فقط.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFF346957),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } else {
      Fluttertoast.showToast(
          msg: "تم الإرسال!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFF346957),
          textColor: Colors.white,
          fontSize: 15.0);
    }
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SupervisorHomepage()));
  }
}
