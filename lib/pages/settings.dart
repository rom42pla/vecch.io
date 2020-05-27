import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/pages/loginOrRegister.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';
import 'login.dart';
import 'package:vecchio/providers/database.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _username = "";
  String _email = "";
  String _name = "";
  String _surname = "";
  DateTime _registrationDate;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseProvider().getLoggedUserCredentialsFromLocalStorage(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _name = snapshot.data["name"];
            _surname = snapshot.data["surname"];
            _username = snapshot.data["username"];
            _email = snapshot.data["email"];
            try {
              _registrationDate =
                  DateTime.parse(snapshot.data["registration_date"]);
            } catch (e) {
              _registrationDate = DateTime(1492);
            }
            return Scaffold(
                body: ListView(
              children: <Widget>[
                Card(
                    child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person, size: 64),
                    title: Text("$_name $_surname (@$_username)"),
                    subtitle: Text("Registered on vecch.io since " +
                        _registrationDate.month.toString() +
                        "/" +
                        _registrationDate.day.toString() +
                        "/" +
                        _registrationDate.year.toString() +
                        "\n"
                            "3 medicines registered"),
                    isThreeLine: true,
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Delete account?"),
                                  content: Text(
                                      "Are you sure you want to delete your account from vecch.io?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("I'VE CHANGED MY MIND"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("DELETE ACCOUNT",
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () async {
                                        await DatabaseProvider()
                                            .deleteUser();
                                        await DatabaseProvider().clearLocalStorage();
                                        Navigator.pushReplacementNamed(
                                            context,
                                            "/");
                                      },
                                    )
                                  ],
                                );
                              });
                          //Navigator.pushReplacement(context,
                          //  MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        child: Text("DELETE ACCOUNT",
                            style: TextStyle(color: Colors.red)),
                      ),
                      FlatButton(
                        onPressed: () async {
                          await DatabaseProvider().clearLocalStorage();
                          Navigator.pushReplacementNamed(
                              context,
                              "/");
                        },
                        child: Text("LOGOUT"),
                      )
                    ],
                  )
                ])),
              ],
            ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
