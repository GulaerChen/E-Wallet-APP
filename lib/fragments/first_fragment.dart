import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class FirstFragment extends StatelessWidget {
  String nowTime;
  // Style
  double iconSizeB = 60.0;
  double iconSizeM = 40.0;
  double iconSizeS = 20.0;

  final style1 = TextStyle(fontSize: 60,
      fontWeight: FontWeight.w600,
      color: Colors.white);
  final style2 = TextStyle(fontSize: 20,
      fontWeight: FontWeight.w200,
      color: Colors.white,
      fontStyle: FontStyle.italic);
  final style3 = TextStyle(fontSize: 40,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(context),

        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            // add wallet
              IconButton(
                  icon: Icon(Icons.add_box,color: Colors.green,),
                  iconSize: iconSizeB,
                  onPressed: () {
                    addWallet(context);
                    print('press add wallet icon');
                  }
              )
            ,],
          ),
        ),
      ),
    );
  }

  // list all wallets from FireBase
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('/demo/gulaer/wallets').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  var dID, fromID, moneyFrom, moneyType;
  final name2id = Map<String, String>();
  final name2type = Map<String, String>();
  final name2balance = Map<String, int>();
  final id2name = Map<String, String>();

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (context, idx) {
        print(idx);
        String deleteWarning ="Can not delete non-empty wallet!";
        var name = snapshot[idx].data['name'];
        var type = snapshot[idx].data['type'];
        var balance = snapshot[idx].data['balance'];
        var id = snapshot[idx].documentID;

        // generate the map for transfer money
        name2id.putIfAbsent(name,() => id.toString());
        name2type.putIfAbsent(name,() => type);
        name2balance.putIfAbsent(name,() => balance);

        id2name.putIfAbsent(id.toString(),() => name);

        return Card(
          child: Container(
            padding: EdgeInsets.only(top:5.0),
            height: 100,
            color: Colors.brown,
            child: Column(children: <Widget>[
              Text(name,style: style2),
              Row(children: <Widget>[
                Container( child: Text(type,style: style1),
                           width: 150,
                           padding: EdgeInsets.only(left:20.0),),
                Container( child: Text(balance.toString(),style: style3),
                           width: 120,),
                IconButton(
                  icon: Icon(Icons.sync),
                  iconSize: iconSizeM,
                  color:Colors.blue,
                  onPressed: () async {
                    print('press sync');
                    fromID = id.toString();
                    moneyFrom = balance;
                    moneyType = type;
                    transfer(context);
                  },),
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  iconSize: iconSizeM,
                  color:Colors.redAccent,
                  onPressed: () async {
                    dID = snapshot[idx].documentID.toString();
                    if (snapshot[idx].data['balance'] == 0)
                      deleteWallet(context);
                    else
                      cannotDo(context,deleteWarning);
                    },
                  ),
                ],),
              ],)
          ),
        );
      },);
  }

  void addWallet(BuildContext context) {
    var getName;
    var getType;

    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  helperText: 'Account',
                ),
                onChanged: (name) {
                  getName = name;
                }
            ),
            content: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  helperText: 'Type of Money.',
                ),
                onChanged: (type) {
                  getType = type;
                }
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () async {
                  getTime();
                  if(getName==null || getType==null)
                    cannotDo(context, 'Incomplete input');
                  else if(name2id.containsKey(getName))
                    cannotDo(context, 'Repeated wallet name');
                  else{
                    Firestore.instance.collection('/demo/gulaer/wallets')
                      .document().setData({'balance': 0,
                                           'name': getName,
                                           'type': getType,
                                          });
                    Firestore.instance.collection('/demo/gulaer/actions')
                      .document().setData({'action': 'add',
                                           'wallet name': getName,
                                           'type': getType,
                                           'time': nowTime,
                                         });
                    Navigator.of(context).pop();
                  }
                },
                child: new Text("OK"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Cancel"),
              ),
            ],
          );
        });
  }

  void deleteWallet(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text('Delete this wallet.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () async {
                  getTime();
                  Firestore.instance.collection('/demo/gulaer/wallets')
                      .document(dID).delete();
                  Firestore.instance.collection('/demo/gulaer/actions')
                      .document().setData({'action': 'delete',
                                           'wallet name': id2name[dID],
                                           'time': nowTime,
                  });
                  Navigator.of(context).pop();
                },
                child: new Text("Yes"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("Cancel"),
              ),
            ],
          );
        });
  }

  void cannotDo(BuildContext context, String waring) {
    print('show cannotTransfer');
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: Text(waring),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("OK"),
              ),
            ],
          );
        });
  }

  String toWallet;
  int transferMoney;

  void transfer(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title:
            TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  helperText: 'Deposit Account',

                ),
                onChanged: (to) {
                  toWallet = to;
                  print(to);
                }
            ),
            content:  TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  helperText: 'Send Amount',
                ),
                onChanged: (money) {
                  transferMoney = int.parse(money);
                  print(money);
                }
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () async {
                 if (name2id[toWallet]==null){
                   String warning = "Wallet is not exist.";
                   cannotDo(context,warning);
                 }
                 else if (name2type[toWallet]!=moneyType) {
                   print('cannot_transfer');
                   String warning = "Different type of money.";
                   cannotDo(context,warning);

                 }
                 else {
                   if((moneyFrom - transferMoney)>=0) {
                     Firestore.instance.collection('/demo/gulaer/wallets')
                         .document(fromID).updateData({
                       'balance': moneyFrom - transferMoney,
                     });
                     Firestore.instance.collection('/demo/gulaer/wallets')
                         .document(name2id[toWallet]).updateData({
                       'balance': name2balance[toWallet] + transferMoney,
                     });
                     Firestore.instance.collection('/demo/gulaer/actions')
                         .document().setData({'action': 'transfer',
                                              'walletFrom': id2name[fromID],
                                              'walletTo': toWallet,
                                              'transferMoney': transferMoney,
                                              'time': nowTime,
                                              });
                     Navigator.of(context).pop();
                   }
                   else{
                     print('no_money');
                     String warning = "No enough money.";
                     cannotDo(context,warning);
                   }
                 }
                },
                child: new Text("確認"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  void getTime(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm');
    nowTime = formatter.format(now);
  }
}
