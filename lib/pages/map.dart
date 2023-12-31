import 'dart:async';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hima_front_end/pages/officer.dart';

class MapScreen extends StatefulWidget {
  final int area;
  const MapScreen({super.key, required this.area});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Set<Marker> markers = {};

  //road in nimra mosque
  Set<Polygon> pArea1() {
    List<LatLng> boundArea1 = [
      const LatLng(21.3527671, 39.9639548),
      const LatLng(21.3504605, 39.9678601),
      const LatLng(21.3503943, 39.9677769),
      const LatLng(21.352672, 39.963899), //updated because of error in typing
      const LatLng(21.3527671, 39.9639548)
    ];
    var polygonSet = Set<Polygon>();
    polygonSet.add(
      Polygon(
          fillColor: const Color.fromARGB(0, 0, 0, 0),
          polygonId: const PolygonId('area1'),
          points: boundArea1,
          strokeColor: const Color(0xFFF3D758),
          strokeWidth: 2),
    );
    return polygonSet;
  }

  //other side road in nimra mosque
  Set<Polygon> pArea2() {
    List<LatLng> boundArea2 = [
      const LatLng(21.3552368, 39.9656999),
      const LatLng(21.3529654, 39.9697091),
      const LatLng(21.3528696, 39.9696565),
      const LatLng(21.3551522, 39.9656030),
      const LatLng(21.3552368, 39.9656999)
    ];
    var polygonSet = Set<Polygon>();
    polygonSet.add(
      Polygon(
          fillColor: const Color.fromARGB(0, 0, 0, 0),
          polygonId: const PolygonId('area2'),
          points: boundArea2,
          strokeColor: const Color(0xFFF3D758),
          strokeWidth: 2),
    );
    return polygonSet;
  }

  //arafa mountain
  Set<Polygon> pArea3() {
    List<LatLng> boundArea3 = [
      const LatLng(21.3555936, 39.9822563),
      const LatLng(21.3541446, 39.9853361),
      const LatLng(21.3530196, 39.9844729),
      const LatLng(21.3541681, 39.9815856),
      const LatLng(21.3555936, 39.9822563)
    ];
    var polygonSet = Set<Polygon>();
    polygonSet.add(
      Polygon(
          fillColor: const Color.fromARGB(0, 0, 0, 0),
          polygonId: const PolygonId('area3'),
          points: boundArea3,
          strokeColor: const Color(0xFFF3D758),
          strokeWidth: 2),
    );
    return polygonSet;
  }

  //arafa mountain
  Set<Polygon> pArea4() {
    List<LatLng> boundArea4 = [
      const LatLng(21.3564306, 39.9838213),
      const LatLng(21.3549801, 39.9856491),
      const LatLng(21.3541446, 39.9853361),
      const LatLng(21.3555936, 39.9822563),
      const LatLng(21.3564306, 39.9838213)
    ];
    var polygonSet = Set<Polygon>();
    polygonSet.add(
      Polygon(
          fillColor: const Color.fromARGB(0, 0, 0, 0),
          polygonId: const PolygonId('area4'),
          points: boundArea4,
          strokeColor: const Color(0xFFF3D758),
          strokeWidth: 2),
    );
    return polygonSet;
  }

  Set<Polygon> assignedArea(int assigned) {
    if (assigned == 1) {
      return pArea1();
    } else if (assigned == 2) {
      return pArea2();
    } else if (assigned == 3) {
      return pArea3();
    }
    return pArea4();
  }

  //get location
  Position? position;
  late bool servicePermission = false;
  late LocationPermission permission;

  Future<void> _getCurrentLocation() async {
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
    print("got location");
    setState(() async {
      position = await Geolocator.getCurrentPosition();
      if (position != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(position!.latitude, position!.longitude),
            icon: await MarkerIcon.markerFromIcon(
              Icons.circle_outlined,
              Colors.blueAccent,
              10.0,
            ),
          ),
        );
        initialCameraPosition = CameraPosition(
          target: LatLng(position!.latitude, position!.longitude),
          zoom: 14.0,
        );
      }
    });
  }

  //starting map
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(21.3552368, 39.9656999),
    zoom: 14.0,
  );

  static CameraPosition targetPosition = const CameraPosition(
    target: LatLng(21.3529654, 39.9697091),
    zoom: 14.0,
  );

  void targetPositionArea(int area) {
    if (area == 1) {
      setState(() {
        targetPosition = const CameraPosition(
            //road in nimra mosque
            target: LatLng(21.3503943, 39.9677769),
            zoom: 14);
      });
    } else if (area == 2) {
      setState(() {
        targetPosition = const CameraPosition(
            //other side road in nimra mosque
            target: LatLng(21.3528696, 39.9696565),
            zoom: 14);
      });
    } else if (area == 3) {
      setState(() {
        targetPosition = const CameraPosition(

            ///Arafat mountain
            target: LatLng(21.3530196, 39.9844729),
            zoom: 14);
      });
    } else if (area == 4) {
      setState(() {
        targetPosition = const CameraPosition(
            //Arafat mountain
            target: LatLng(21.3541446, 39.9853361),
            zoom: 14);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //handling to show
    _getCurrentLocation();
    targetPositionArea(widget.area);
  }

  goOfficer() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OfficerHomepage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75, //appbar height
        //padding method necessary to push logo to right
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/Hima_logo.jpg',
              height: 70,
              width: 70,
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
              onPressed: () {
                goOfficer();
              },
              backgroundColor: const Color.fromARGB(255, 99, 154, 125),
              child:
                  const Icon(Icons.arrow_right, size: 40, color: Colors.white),
            ),
          ),
        ]),
        backgroundColor: const Color.fromARGB(
            255, 255, 255, 255), //appbar color is transparent
        elevation: 0.0, //remove appbar shadow
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        polygons: assignedArea(widget.area),
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
        label: const Text("المنطقة الجديدة",
            style: TextStyle(
                fontFamily: 'Tajawal', color: Colors.black, fontSize: 20)),
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
