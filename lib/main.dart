import 'package:flutter/material.dart';
import 'package:flutter_codigo3_maps/app/utils/pages_mapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}):super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: PagesMapper.accessGPS.name,
      routes: buildMapRouter(),
    );
  }
}