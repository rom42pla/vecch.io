import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          title: Text("vecch.io"),
        ),*/
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
                flex: 8,
                child: Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    inputText(
                        label: "username",
                        icon: Icons.mail,
                        controller: usernameController),
                    SizedBox(height: 20.0),
                    inputText(
                        label: "password",
                        icon: Icons.vpn_key,
                        obscured: true,
                        controller: passwordController),
                    SizedBox(height: 20.0),
                    Row(children: <Widget>[
                      Expanded(
                          flex: 5,
                          child: Builder(
                            builder: (context) => loginButton(
                                newPage: HomePage(),
                                context: context,
                                usernameController: usernameController,
                                passwordController: passwordController),
                          )),
                      Expanded(
                        flex: 5,
                        child: registerButton(
                            usernameController: usernameController,
                            passwordController: passwordController),
                      )
                    ])
                  ],
                ))),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ));
  }
}
