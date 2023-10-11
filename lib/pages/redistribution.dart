import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

class Redistribution extends StatelessWidget {
  //const Redistribution({super.key});
  int initialValue = 50;
  @override
  Widget build(BuildContext context) {
    int contA = initialValue;
    int contB = initialValue;
    int contC = initialValue;
    int contD = initialValue;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //to center AppBar content
        toolbarHeight: 300, //appbar height
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
      //wrapping column in container so we can align it
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
              width: 370.0,
              height: 230.0,
              decoration: BoxDecoration(
                color: Color(0xFF346957),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              //column represents inside green contaainer
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: Text(
                      "تقسيم جديد",
                      textAlign: TextAlign.right,
                      style: TextStyle(shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          // color of the shadow
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 2),
                        )
                      ], fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    childAspectRatio: (4 / 1.5),
                    children: List.generate(4, (index) {
                      TextEditingController _textEditingController =
                          TextEditingController()
                            ..text =
                                replaceFarsiNumber(initialValue.toString());
                      return Container(
                        //width: 100,
                        //height: 100,
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFfafafa),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: IconButton(
                                iconSize: 15,
                                //splashRadius: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                    minWidth: 22, maxWidth: 22),
                                onPressed: () {
                                  if (index == 0) {
                                    contA--;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contA.toString());
                                  } else if (index == 1) {
                                    contB--;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contB.toString());
                                  } else if (index == 2) {
                                    contC--;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contC.toString());
                                  } else if (index == 3) {
                                    contD--;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contD.toString());
                                  }
                                  print("PRESSED - at index $index");
                                  //setState(() {});
                                },
                                icon: const Icon(
                                  Icons.remove,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 45,
                                height: 25,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF346957),
                                      )),
                                      filled: true,
                                      fillColor: Colors.white),
                                )),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                iconSize: 15,
                                //splashRadius: 20,
                                padding: EdgeInsets.zero,
                                splashColor: Colors.red,
                                onPressed: () {
                                  if (index == 0) {
                                    contA++;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contA.toString());
                                  } else if (index == 1) {
                                    contB++;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contB.toString());
                                  } else if (index == 2) {
                                    contC++;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contC.toString());
                                  } else if (index == 3) {
                                    contD++;
                                    _textEditingController.text =
                                        replaceFarsiNumber(contD.toString());
                                  }
                                  print("PRESSED + at index $index");
                                  //setState(() {});
                                },
                                icon: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ),
                            Text(
                              'المنطقه  ${replaceFarsiNumber((index + 1).toString())} ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //determine floating action button (for redistribution submission) location
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      //wrapping it in a container so we can push it to edge of green container
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 460),
        child: FloatingActionButton(
          foregroundColor: Color(0xFF346957),
          onPressed: () {
            findOfficer(contA, contB, contC, contD);
          },

          ///floataction button submission ACTION
          backgroundColor: Colors.white,
          child: const Icon(Icons.check_sharp),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

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
  }
}
