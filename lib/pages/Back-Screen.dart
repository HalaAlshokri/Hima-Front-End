import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hima_front_end/pages/officer.dart';

class BackScreen extends StatefulWidget {
  const BackScreen({super.key});

  @override
  State<BackScreen> createState() => BackScreenState();
}

class BackScreenState extends State<BackScreen> {
  //------------------------------Location test------------------------------------
  late bool servicePermission = false;
  late LocationPermission permission;
  bool isEnabled = false;

  Future<void> _getLocationPermission() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      print('location enabled');
      isEnabled = true;
    }
    if (isEnabled) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OfficerHomepage()));
    }
  }
  //------------------------------Location test------------------------------------

  @override
  void initState() {
    super.initState();
    //handling location
    _getLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Image.asset(
          'assets/images/Hima_logo.jpg',
          height: 45,
          width: 45,
        ),
        titleSpacing: 10,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        height: 600,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Icon(Icons.location_pin, size: 100, color: Color(0xFFF3D758)),
            const SizedBox(height: 5),
            const Text(
              'الرجاء السماح\n بتعقب موقع الجهاز',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'TajawalBold',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Color.fromARGB(255, 99, 154, 125),
              ),
            ),
            const SizedBox(height: 10),
            MaterialButton(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0))),
              elevation: 5.0,
              height: 40,
              padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
              onPressed: () async {

                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.always ||
                    permission == LocationPermission.whileInUse) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfficerHomepage()));
                }
              },
              color: const Color.fromARGB(255, 99, 154, 125),
              child: const Text(
                "              تعقب الجهاز               ",
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Color(0xFFF3D758),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const noNotificationScreen()),
  );*/
