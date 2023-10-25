import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

class OfficerList extends StatefulWidget {
  @override
  _OfficerListState createState() => _OfficerListState();
}

class _OfficerListState extends State<OfficerList> {
  //officers information in list
  List<String> name = ['afrah', 'nora', 'hala', 'jumanah'];
  List<String> status = ['Available', 'Available', 'not', 'not'];
  List<int> location = [1, 3, 4, 2];

  //retreiving officers info
  Future<void> officersInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      if (doc.data()['role'] == 'officer') {
        name.add(doc.data()['name']);
        print(doc.data()['name']);

        status.add(doc.data()['oStatus']);
        print(doc.data()['oStatus']);

        location.add(doc.data()['oLocation']);
        print(doc.data()['oLocation'].toString());
      }
    }
    //await Future.delayed(const Duration(seconds: 3), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 70, //appbar height
        //padding method necessary to push logo to right
        title: Row(children: [
          Image.asset(
            'assets/images/Hima_logo.jpg',
            height: 70, // was 45
            width: 70, // was 45
          ),
          const SizedBox(
            width: 250,
          ),
          SizedBox(
            width: 55,
            height: 55,
            child: FloatingActionButton(
              mini: true,
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupervisorHomepage()));
              },
              backgroundColor: const Color.fromARGB(255, 99, 154, 125),
              child: const Icon(Icons.keyboard_arrow_right,
                  size: 40, color: Colors.white),
            ),
          ),
        ]),
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
                                  leading: icontest(status, index),
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

  Widget icontest(List<String> status, int index) {
    if (status[index] == 'Available') {
      return const Icon(
        Icons.check_circle_rounded,
        color: Color.fromARGB(255, 99, 154, 125),
      );
    } else {
      return const Icon(
        Icons.do_not_disturb_on_rounded,
        color: Color(0xFFF3D758),
      );
    }
  }
}
