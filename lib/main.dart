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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vecchio/providers/database.dart';
import 'dart:async';


void main() {
  runApp(VecchioApp());
}

class VecchioApp extends StatefulWidget {
  @override
  _VecchioAppState createState() => new _VecchioAppState();
}


class _VecchioAppState extends State<VecchioApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    // Cambiare con un'altra immagine se non si vuole usare quella di default @mipmap/ic_launcher 
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher'); 
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    // QUESTO È IL VECCHIO METODO PER LA NOTIFICA
    /*WidgetsBinding.instance
        .addPostFrameCallback((_) => _showNotificationWithDefaultSound());*/

    Timer.periodic(Duration(seconds: 10), (Timer t) => _checkNotification());

  }

  Future _checkNotification() async {

    Future <Map> notification = DatabaseProvider().getNotification();

    notification.then((value) {
      //print(value);
      if (value["Titolo"] != null){
        _showNotificationWithDefaultSound(value["Titolo"], value["Descrizione"]);
        DatabaseProvider().deleteNotification(value["Titolo"], value["Descrizione"]);
      }
    });
  }

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

  // Questo metodo ancora non funziona ma non è proprio necessario per il funzionamento
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("$payload"),
          content: Text("La notifica verrà cancellata dal database"),
        );
      },
    );
  }

  Future _showNotificationWithDefaultSound(titolo, descrizione) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      titolo,
      descrizione,
      platformChannelSpecifics,
      payload: 'Notifica visualizzata',
    );
  }
}