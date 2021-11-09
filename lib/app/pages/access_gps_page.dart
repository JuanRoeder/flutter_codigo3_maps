import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codigo3_maps/app/utils/pages_mapper.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessGPSPage extends StatefulWidget {
  const AccessGPSPage({Key? key}) : super(key: key);

  @override
  State<AccessGPSPage> createState() => _AccessGPSPageState();
}

class _AccessGPSPageState extends State<AccessGPSPage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print("STATE:::::: $state");
    if(state == AppLifecycleState.resumed){
      Permission.location.isGranted.then(
            (value) {
          if (value) {
            accessLocation(context, PermissionStatus.granted);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Es necesario activar el GPS"),
            const SizedBox(
              height: 10,
            ),
            CupertinoButton(
              color: Colors.black87,
              child: const Text("Activar GPS"),
              onPressed: () async {
                accessLocation(context, await Permission.location.request());
              },
            ),
          ],
        ),
      ),
    );
  }

  void accessLocation(BuildContext context, PermissionStatus status) {
    print(status);
    switch (status) {
      case PermissionStatus.granted:
        PagesMapper.homePage.pushReplacement(context);
        break;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
        openAppSettings();
        break;
    }
  }
}
