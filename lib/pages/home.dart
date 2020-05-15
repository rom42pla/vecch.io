import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';
import 'settings.dart';
import 'medicines.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  int _currView = 0;
  List<Widget> _views = <Widget>[
    MedicinesPage(),
    SettingsPage()
  ];
  void _onItemTapped(int view) {
    setState(() {
      _currView = view;
    });
    print(view);
  }
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore Demo'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Create Record'),
            onPressed: () {
              createRecord();
            },
          ),
          RaisedButton(
            child: Text('View Record'),
            onPressed: () {
              getData();
            },
          ),
          RaisedButton(
            child: Text('Update Record'),
            onPressed: () {
              updateData();
            },
          ),
          RaisedButton(
            child: Text('Delete Record'),
            onPressed: () {
              deleteData();
            },
          ),
        ],
      )), //center
    );
  }

  void createRecord() async {
    await databaseReference.collection("Medicine")
        .document("Luigi")
        .setData({
          'Medicine': 3
        });
  }

  void getData() {
    databaseReference
        .collection("Medicine")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void updateData() {
    try {
      databaseReference
          .collection('Medicine')
          .document('Luigi')
          .updateData({'Medicine': 2});
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteData() {
    try {
      databaseReference
          .collection('Medicine')
          .document('Luigi')
          .delete();
    } catch (e) {
      print(e.toString());
    }
/*
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: _views.elementAt(_currView),
        ),
        bottomNavigationBar:
            homeBottomBar(view: _currView, onTap: _onItemTapped));*/
  }
}
