import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class TestMap extends StatefulWidget {
  // const TestMap({super.key});
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destinationLocation = LatLng(37.33500926, -122.03272188);
  final Completer<GoogleMapController> _controller = Completer();

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tracking",style: TextStyle(color: Colors.black, fontSize: 16),),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: TestMap.sourceLocation,zoom: 14.5),
        markers: {
          Marker(markerId: MarkerId("source"),
          position: TestMap.sourceLocation
          ),
        },
      ),
    );
  }
}