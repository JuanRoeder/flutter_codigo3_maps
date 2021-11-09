import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_codigo3_maps/app/utils/map_style.dart';
import 'package:flutter_codigo3_maps/app/utils/my_assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(
      -12.025827,
      -77.0679845,
    ),
    zoom: 11,
  );

  Map<MarkerId, Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        scrollGesturesEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (controller) =>
            controller.setMapStyle(json.encode(mapStyle)),
        onTap: (argument) async {
          print(argument);
          final markerId = MarkerId(markers.length.toString());
          final icon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), MyAssetsImages.hospital.src);
          setState(
            () => markers[markerId] = Marker(
              markerId: markerId,
              position: argument,
              draggable: true,
              onDragEnd: (value) => print(value),
              icon: icon,
              rotation: -10,
              anchor: const Offset(0.5, 0.5),
              infoWindow: const InfoWindow(title: "Title", snippet: "Snippet"),
              // onTap: () => ,
            ),
          );
        },
        markers: markers.values.toSet(),
      ),
    );
  }
}
