import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SecondFragment extends StatelessWidget {
  // Style
  double iconSizeB = 60.0;
  double iconSizeM = 40.0;
  double iconSizeS = 20.0;

  final style2 = TextStyle(fontSize: 20,
      fontWeight: FontWeight.w200,
      color: Colors.white,);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(context),
      ),
    );
  }

  // list all wallets from FireBase
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('/demo/gulaer/actions').snapshots(),
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

        var actionType = snapshot[idx].data['action'];
        String showText;
        if (actionType =='add' || actionType =='delete')
          showText = snapshot[idx].data['wallet name'];
        else {
          String transferMoney = snapshot[idx].data['transferMoney'].toString();
          String walletFrom = snapshot[idx].data['walletFrom'];
          String walletTo = snapshot[idx].data['walletTo'];
          String type = snapshot[idx].data['type'];
          showText = type + " " + transferMoney +
                      " (" + walletFrom + ' > ' +walletTo+" )";
        }

        return Card(
          child: Container(
              padding: EdgeInsets.only(top:5.0),
              height: 80,
              color: Colors.brown,
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.access_time),
                    iconSize: iconSizeS,
                    color: Colors.white,
                    onPressed: (){},),
                  Column( children: <Widget>[
                  Container( child: Text(actionType,style: style2),
                    padding: EdgeInsets.only(left:5),
                    width: 230,),
                  Container( child: Text(showText,style: style2),
                    padding: EdgeInsets.only(left:5,top:5),
                    width: 230,),],),
                  Container( child: Text(snapshot[idx].data['time']
                             ,style: style2),
                    padding: EdgeInsets.only(right:5),),
                ],),
              ],)
          ),
        );
      },);
  }

}