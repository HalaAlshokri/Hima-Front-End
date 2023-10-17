import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hima_front_end/pages/Back-Screen.dart';
import 'package:hima_front_end/pages/officer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  //get location
  Position? _currentlocation;
  late bool servicePermission = false;
  late LocationPermission permission;

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BackScreen()));
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BackScreen()));
        return Future.error('Location permissions are denied');
      }
    }
    print("got location");
    return await Geolocator.getCurrentPosition();
  }

  //starting map
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(21.3552368, 39.9656999),
    zoom: 14.0,
  );

  static const CameraPosition targetPosition = CameraPosition(
    target: LatLng(21.3529654, 39.9697091),
    zoom: 14.0,
    bearing: 192.0,
    tilt: 60,
  );

  Set<Marker> markers = {};

  @override
  Future<void> initState() async {
    super.initState();
    //handling to show
    Position position = await _getCurrentLocation();
    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude)));
    markers.add(const Marker(
        markerId: MarkerId('New assigned location'),
        position: LatLng(21.3529654, 39.9697091)));
  }

  goOfficer() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OfficerHomepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60, //appbar height
        //padding method necessary to push logo to right
        title: Row(children: [
          Image.asset(
            'assets/images/Hima_logo.jpg',
            height: 45,
            width: 45,
          ),
          const SizedBox(
            width: 190,
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () async {
              await goOfficer();
            },
            backgroundColor: const Color.fromARGB(255, 99, 154, 125),
            child: const Icon(Icons.arrow_right, size: 20, color: Colors.white),
          ),
        ]),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          toNewArea();
        },
        backgroundColor: Colors.white,
        label: const Text("To NEW Area"),
        icon: const Icon(Icons.fmd_good_rounded,
            color: Color.fromARGB(255, 179, 0, 0)),
      ),
    );
  }

  Future<void> toNewArea() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  }
}
