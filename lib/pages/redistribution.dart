import 'package:flutter/material.dart';

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
                            Text(
                              'المنطقه  ${replaceFarsiNumber((index + 1).toString())} ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
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
                                height: 20,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  controller: _textEditingController,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                        width: 2,
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
                          ],
                        ),
                      );
                    }),
                  ),
                  /*ElevatedButton(
                        child: Text(
                          '✓',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 6, 107, 86)),
                        onPressed: () {
                          print('new Distrbution submitted');
                        })
                    //1st Row for area 1,2 redistribution
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Area 2 container
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "منطقة 1",
                                style: TextStyle(
                                  color: Color(0xFF346957),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        //Area 1 container
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ],
                    ),
                    //2st Row for area 1,2 redistribution
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Area 4 container
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        SizedBox(width: 15),
                        //Area 3 container
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ],
                    )*/
                ],
              ),
            ),

            /*FloatingActionButton(
              foregroundColor: Color(0xFF346957),
              onPressed: () {},
              backgroundColor: Colors.white,
              child: const Icon(Icons.check_sharp),
            )*/
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 460),
        child: FloatingActionButton(
          foregroundColor: Color(0xFF346957),
          onPressed: () {},
          backgroundColor: Colors.white,
          child: const Icon(Icons.check_sharp),
        ),
      ),
    );
  }
}
