import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';
import 'settings.dart';
import 'medicines.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currView = 0;
  List<Widget> _views = <Widget>[MedicinesPage(), SettingsPage()];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: _views.elementAt(_currView),
        ),
        bottomNavigationBar: homeBottomBar(
            view: _currView,
            onTap: (view) => setState(() {
                  _currView = view;
                })));
  }
}
