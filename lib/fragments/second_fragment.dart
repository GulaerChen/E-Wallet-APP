import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SecondFragment extends StatelessWidget {
  double icon_size = 60.0;
//  List colors = [Colors.red, Colors.green, Colors.yellow];
//  Random random = new Random();
//  int index = 0;
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ Flexible(
              child:
              StreamBuilder<int>(
                  stream: _streamController.stream,
                  initialData: _counter,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                    return Text('I have ${snapshot.data} millions.',
                      style: TextStyle(fontSize: 30.0,color: Colors.white,),);}),
            ),],),),


        // 新增刪除錢包按紐
        bottomNavigationBar: BottomAppBar(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon:Icon(Icons.delete_forever),
                iconSize: icon_size,
                onPressed:(){
//            async{ Firestore.instance.collection('wallet').document()
//                  .setData({'UserID': 'Gulaer', 'WalletID': '0002'});
                  print('Icon delete is press');
//              _streamController.sink.add(--_counter);
                },
              )
              ,
              Text(" event operation"),
              IconButton(
                icon:Icon(Icons.add_box),
                iconSize: icon_size,
                onPressed: () {

//                _streamController.sink.add(++_counter);
                },
              )
            ],
          ),
          color: Colors.white,
        ),
      ),);
  }


}