import 'dart:async';
import 'package:flutter/material.dart';

class SecondFragment extends StatelessWidget {
  final String url = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.

    return new Scaffold(body: new SafeArea(
        child: Container(child: Column(children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Text("Verify and Select a Single Listing?",),
          ),
          Expanded(child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: _getListings(), // <<<<< Note this change for the return type
          ),
          )
        ])
        )));
  }

  List<Widget> _getListings() {
    // <<<<< Note this change for the return type
    List listings = new List<Widget>();
    int i = 0;
    for (i = 0; i < 4; i++) {
      listings.add(
        new RadioListTile<String>(
          title: const Text('Lafayette'),
          value: "c",
          groupValue: "x",
          onChanged: (_) {

          },
        ),
      );
    }
    return listings;
  }
}