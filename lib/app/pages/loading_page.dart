import 'package:flutter/material.dart';
import 'package:flutter_codigo3_maps/app/utils/pages_mapper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: checkGPSAndLocation(),
        builder: (context, snapshot) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> checkGPSAndLocation() async {
    final permissionLocation = await Permission.location.isGranted;
    final gpsActive = await Geolocator.isLocationServiceEnabled();
    if (permissionLocation && gpsActive) {
      PagesMapper.homePage.pushReplacement(context);
    }else if(!permissionLocation){
      PagesMapper.accessGPS.pushReplacement(context);
    }else{
      Geolocator.openLocationSettings();
    }
  }
}
