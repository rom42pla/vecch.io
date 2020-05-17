import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vecchio/pages/loginOrRegister.dart';
import 'package:vecchio/pages/medicines.dart';
import 'package:vecchio/pages/settings.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'widgets/inputs.dart';
import 'widgets/text.dart';

void main() => runApp(VecchioApp());

class VecchioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vecch.io',
      theme: new ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        brightness: Brightness.light,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginOrRegisterPage(),
        '/editMedicine': (context) => EditMedicinePage(),
        '/medicines': (context) => MedicinesPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
