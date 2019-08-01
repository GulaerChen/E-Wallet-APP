import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';

class FirstFragment extends StatelessWidget {
  double icon_size = 60.0;
  double test_cover = 0;
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(context),

        // 功能按紐列
        bottomNavigationBar: BottomAppBar(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              // 刪除
              IconButton(
                icon:Icon(Icons.delete_forever),
                iconSize: icon_size,
                onPressed: () {
                  print('press delete');
                },),

              // 轉帳
              IconButton(
                icon:Icon(Icons.sync),
                iconSize: icon_size,
                onPressed: () {
                  print('press sync');
                },),

              // 新增
              IconButton(
                icon:Icon(Icons.add_box),
                iconSize: icon_size,
                onPressed: ()
                async{

                  Firestore.instance.collection('/demo/gulaer/wallets')
                      .document('004')
                      .setData({'balance': 0,
                    'name': 'BBBBB',
                    'type':'NT',
                  });
                  print('press add');
                },),

            ],
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('/demo/gulaer/wallets').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (context, idx) {
        print(idx);
        return Card(
          child: Container(
              height: 150,
              color: Colors.brown,
              child: Column(children: <Widget>[
                Text(snapshot[idx].data['name'],
                    style: style2),
                Row( children: <Widget>[
                  Text(snapshot[idx].data['type'],
                      style: style1),
                  Text(snapshot[idx].data['balance'].toString(),
                      style: style1),
                ],),
              ],)
          ),
        ); // Container, Card
      },);
  }

  // TextStyle
  final style1 = TextStyle(fontSize:60,
      fontWeight:FontWeight.w500,
      color:Colors.white);
  final style2 = TextStyle(fontSize:20.0,
      fontWeight:FontWeight.w200,
      color:Colors.white,
      fontStyle:FontStyle.italic);


//  void showCupertinoDialog() {
//    var dialog = CupertinoAlertDialog(
//      content: Text(
//        "HIHI~~~",
//        style: TextStyle(fontSize: 20),
//      ),
//      actions: <Widget>[
//        CupertinoButton(
//          child: Text("取消"),
//          onPressed: () {
//          },
//        ),
//        CupertinoButton(
//          child: Text("確定"),
//          onPressed: () {
//          },
//        ),
//      ],
//    );



}
