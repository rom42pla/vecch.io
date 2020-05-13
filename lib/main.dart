import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to Flutter', home: HomePage());
  }
}

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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("vecch.io"),
        ),
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
                            label: "username or email",
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
                            child: loginButton(
                                usernameController: usernameController,
                                passwordController: passwordController),
                          ),
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

Widget inputText(
    {String label,
      IconData icon = null,
      bool obscured = false,
      var controller = null}) {
  return TextFormField(
    controller: controller,
    // obscures text or not
    obscureText: obscured,
    autocorrect: false,
    keyboardType: (!obscured)
        ? TextInputType.emailAddress
        : TextInputType.visiblePassword,
    // aesthetic decorations
    decoration: InputDecoration(
      labelText: label,
      icon: Icon(icon),
      isDense: true,
      border: OutlineInputBorder(),
    ),
  );
}

Widget loginButton(
    {TextEditingController usernameController,
      TextEditingController passwordController}) {
  return FlatButton(
    onPressed: () {
      String username = usernameController.text;
      String password = passwordController.text;
      // process data
      print(username + " " + password);
    },
    child: Text("LOGIN"),
  );
}

Widget registerButton(
    {TextEditingController usernameController,
      TextEditingController passwordController}) {
  return FlatButton(
    onPressed: () {
      String username = usernameController.text;
      String password = passwordController.text;
      // process data
      print(username + " " + password);
    },
    child: Text("REGISTER"),
  );
}
