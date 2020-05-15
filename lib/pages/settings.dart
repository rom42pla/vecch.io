import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Card(
            child: Column(children: <Widget>[
          ListTile(
            leading: Icon(Icons.person, size: 64),
            title: Text("Sergio Catacci"),
            subtitle: Text(
                "Registered on vecch.io since 13/32/2020\n" // TODO check database for infos
                "3 medicines registered"),
            isThreeLine: true,
          ),
          ButtonBar(
            children: <Widget>[
              logoutButton(context: context),
            ],
          )
        ])),
      ],
    ));
  }
}
