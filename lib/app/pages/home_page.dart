import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_codigo3_maps/app/utils/map_style.dart';
import 'package:flutter_codigo3_maps/app/utils/my_assets.dart';
import 'package:flutter_codigo3_maps/app/utils/my_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraPosition? _initialCameraPosition;
  Map<MarkerId, Marker> markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _points = [];

  Future<CameraPosition> initiateCurrentPosition() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    _initialCameraPosition = CameraPosition(
      target: currentPosition.toLatLng(),
      zoom: 14,
    );
    return _initialCameraPosition!;
  }

  getCurrentPositionAndController(GoogleMapController controller) {
    _polylines.add(
      Polyline(
        polylineId: const PolylineId("ruta_repartidor"),
        points: _points,
        color: Colors.deepPurpleAccent,
        width: 7,
      ),
    );

    Geolocator.getPositionStream(
      distanceFilter: 10,
      desiredAccuracy: LocationAccuracy.high,
    ).listen(
      (position) async {
        LatLng pos = position.toLatLng();
        CameraUpdate cameraUpdate = CameraUpdate.newLatLng(pos);
        controller.animateCamera(cameraUpdate);
        const markerId = MarkerId("truck");
        final icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          MyAssetsImages.truck.src,
        );
        setState(
          () {
            _points.add(pos);
            markers[markerId] = Marker(
              markerId: markerId,
              position: pos,
              icon: icon,
            );
          },
        );
      },
    );
  }

  void back2CurrentPosition() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: FloatingActionButton(
          onPressed: back2CurrentPosition,
          child: const Icon(
            Icons.gps_fixed,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: FutureBuilder<CameraPosition>(
          future: initiateCurrentPosition(),
          builder: (context, snapshot) {
            if (!snapshot.hasData && _initialCameraPosition == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GoogleMap(
              initialCameraPosition: _initialCameraPosition!,
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                controller.setMapStyle(json.encode(mapStyle));
                getCurrentPositionAndController(controller);
              },
              polylines: _polylines,
              // onTap: (argument) async {
              //   print(argument);
              //   final markerId = MarkerId(markers.length.toString());
              //   final icon = await BitmapDescriptor.fromAssetImage(
              //       const ImageConfiguration(), MyAssetsImages.hospital.src);
              //   setState(
              //     () => markers[markerId] = Marker(
              //       markerId: markerId,
              //       position: argument,
              //       draggable: true,
              //       onDragEnd: (value) => print(value),
              //       icon: icon,
              //       rotation: -10,
              //       anchor: const Offset(0.5, 0.5),
              //       infoWindow: const InfoWindow(
              //         title: "Title",
              //         snippet: "Snippet",
              //       ),
              //     ),
              //   );
              // },
              markers: markers.values.toSet(),
            );
          },
        ),
      ),
    );
  }
}
