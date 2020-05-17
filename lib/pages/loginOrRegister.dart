import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/pages/login.dart';
import 'package:vecchio/pages/register.dart';
import 'package:vecchio/providers/database.dart';
import 'home.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

class LoginOrRegisterPage extends StatefulWidget {
  @override
  _LoginOrRegisterPageState createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text("Welcome to vecch.io!"),
                bottom: TabBar(
                  tabs: [
                    Tab(text: "Login"),
                    Tab(text: "Register"),
                  ],
                )),
            body: TabBarView(children: <Widget>[
              LoginPage(),
              RegisterPage()
            ],)
            ));
  }
}
