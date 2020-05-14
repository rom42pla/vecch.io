import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/pages/home.dart';

Widget loginButton(
    {var newPage,
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController passwordController}) {
  return FlatButton(
    onPressed: () {
      String username = usernameController.text;
      String password = passwordController.text;
      if (newPage != null) {
        FocusScope.of(context).unfocus();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      // process data
      print("Logged $username with password $password");
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

Widget homeBottomBar({var view, var onTap}) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        title: Text('Business'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        title: Text('School'),
      ),
    ],
    currentIndex: view,
    //selectedItemColor: Colors.brown,
    onTap: onTap,
  );
}
