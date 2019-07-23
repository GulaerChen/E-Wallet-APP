import 'package:drawer_demo/pages/home_page.dart';
import 'package:flutter/material.dart';

//void manin(){
// return runApp(new MyApp());
// }

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NavigationDrawer Demo',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new HomePage(),
    );
  }
}