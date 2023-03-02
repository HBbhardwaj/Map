import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OderTrackingPage extends StatefulWidget {
  const OderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OderTrackingPage> createState() => _OderTrackingPageState();
}

class _OderTrackingPageState extends State<OderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500927, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  LatLng? currentPostion = sourceLocation;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Map"),
        backgroundColor: Colors.green.shade100,
      ),
      body: GoogleMap(
        // onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: currentPostion!,
          zoom: 10,
        ),
      ),
    );
  }
}
