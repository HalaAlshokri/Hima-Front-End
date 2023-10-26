import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hima_front_end/pages/redistribution.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

class OfficerList extends StatefulWidget {
  @override
  _OfficerListState createState() => _OfficerListState();
}

class _OfficerListState extends State<OfficerList> {
  //officers information in list
  List<String> name = [];
  List<String> status = [];
  List<int> location = [];

  //retreiving officers info
  Future<void> officersInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      if (doc.data().isNotEmpty) {
        if (doc.data()['role'] == 'officer') {
          name.add(doc.data()['name']);
          print(doc.data()['name']);

          status.add(doc.data()['oStatus']);
          print(doc.data()['oStatus']);

          location.add(doc.data()['oLocation']);
          print(doc.data()['oLocation'].toString());
        }
      }
    }
    setState(() {});
    //await Future.delayed(const Duration(seconds: 3), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(children: [
            Card(
              color: const Color.fromARGB(255, 99, 154, 125),
              child: ListTile(
                trailing: fixedTextWhite('المنطقة'),
                leading: fixedTextWhite('الحالة'),
                titleAlignment: ListTileTitleAlignment.center,
                title: Container(
                  alignment: Alignment.center,
                  child: fixedTextWhite('الاسم'),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: officersInfo(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Color(0xFFF3D758),
                    strokeWidth: 6,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SizedBox(
                    //size of the outer box list
                    height: 500,
                    //width: 280,
                    //list view builder
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: name.length,
                            (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  tileColor: Colors.white,
                                  trailing: fixedTextBlack(
                                      location[index].toString()),
                                  leading: icontest(status[index]),
                                  titleAlignment: ListTileTitleAlignment.center,
                                  title: Center(
                                    child: fixedTextBlack(name[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: GNav(
            selectedIndex: 2,
            onTabChange: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupervisorHomepage()));
              } else if (index == 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Redistribution(
                            zone1: 25,
                            zone2: 25,
                            zone3: 25,
                            zone4: 25,
                            isModel: false)));
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

  Widget fixedTextWhite(String word) {
    return Text(
      word,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  Widget fixedTextBlack(String word) {
    return Text(
      word,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget fixedTextYellow(String word) {
    return Text(
      word,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFFF3D758),
      ),
    );
  }

  Widget icontest(String status) {
    if (status == 'Available') {
      return fixedTextBlack('متاح');
    } else {
      return fixedTextYellow('مشغول');
    }
  }
}
