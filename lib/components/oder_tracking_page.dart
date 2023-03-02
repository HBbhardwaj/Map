import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
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
  LatLng currentPostion = sourceLocation;
  static CameraPosition _kGoogle = CameraPosition(
    target: LatLng(sourceLocation.latitude, sourceLocation.longitude),
    zoom: 10,
  );

  @override
  void initState() {
    _getUserLocation();
    super.initState();
  }

  void _getUserLocation() async {
    await Geolocator.requestPermission().then((value) async {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((value) {
        if (value != null) {
          setState(() {
            currentPostion = LatLng(value.latitude, value.longitude);
            _kGoogle = CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );
          });
        }
      });
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
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

        mapType: MapType.normal,
        // on below line setting user location enabled.
        myLocationEnabled: true,
        // on below line setting compass enabled.
        compassEnabled: true,

        onMapCreated: (controller) {
          _controller.complete(controller);

          Future.delayed(Duration(seconds: 1), () async {
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: currentPostion,
                  zoom: 14.0,
                ),
              ),
            );
          });
        },
        initialCameraPosition: _kGoogle,

        markers: Set<Marker>.of([
           Marker(
            markerId: MarkerId("1"),
            position: LatLng(currentPostion.latitude, currentPostion.longitude),
            infoWindow: InfoWindow(
              title: 'My Current Location',
            ),
          )
        ]),
      ),
    );
  }
}
