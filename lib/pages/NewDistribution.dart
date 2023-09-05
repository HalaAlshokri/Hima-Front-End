import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
      home: Directionality(
          textDirection: TextDirection.rtl, child: newDistrbution())));
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

class newDistrbution extends StatelessWidget {
  int initialValue = 50;
  Widget build(BuildContext context) {
    int contA = initialValue;
    int contB = initialValue;
    int contC = initialValue;
    int contD = initialValue;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
            child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 70,
        )),
      ),
      backgroundColor: Color.fromARGB(255, 6, 107, 86),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'تقسيم جديد',
                style: TextStyle(
                    fontSize: 22,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
              //-------------------------------start of gridview-------------------------------
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: (4 / 1.5),
                children: List.generate(4, (index) {
                  TextEditingController _textEditingController =
                      TextEditingController()
                        ..text = replaceFarsiNumber(initialValue.toString());
                  return Container(
                    margin: EdgeInsets.all(2.5),
                    padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 6, 107, 86),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'المنطقه${replaceFarsiNumber((index + 1).toString())} ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 25,
                          height: 20,
                          child: ElevatedButton(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white, onPrimary: Colors.black),
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
                            },
                          ),
                        ),
                        SizedBox(
                            width: 50,
                            height: 20,
                            child: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                  filled: true, fillColor: Colors.white),
                            )),
                        SizedBox(
                          width: 25,
                          height: 20,
                          child: ElevatedButton(
                            child: Text(
                              '−',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white, onPrimary: Colors.black),
                            onPressed: () {
                              if (index == 0) {
                                if (contA <= 0) {
                                  contA = 0;
                                } else {
                                  contA--;
                                  _textEditingController.text =
                                      replaceFarsiNumber(contA.toString());
                                }
                              } else if (index == 1) {
                                if (contB <= 0) {
                                  contB = 0;
                                } else {
                                  contB--;
                                  _textEditingController.text =
                                      replaceFarsiNumber(contB.toString());
                                }
                              } else if (index == 2) {
                                if (contC <= 0) {
                                  contC = 0;
                                } else {
                                  contC--;
                                  _textEditingController.text =
                                      replaceFarsiNumber(contC.toString());
                                }
                              } else if (index == 3) {
                                if (contD <= 0) {
                                  contD = 0;
                                } else {
                                  contD--;
                                  _textEditingController.text =
                                      replaceFarsiNumber(contD.toString());
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              //-------------------------------end of gridview-------------------------------
              ElevatedButton(
                  child: Text(
                    '✓',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 6, 107, 86)),
                  onPressed: () {
                    print('new Distrbution submitted');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
