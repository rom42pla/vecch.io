import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

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

  // views setter
  int _currView = 0;
  List<Widget> _views = <Widget>[
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];
  void _onItemTapped(int view) {
    setState(() {
      _currView = view;
    });
    print(view);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("vecch.io"),
        ),
        body: Center(
          child: _views.elementAt(_currView),
        ),
        bottomNavigationBar:
            homeBottomBar(view: _currView, onTap: _onItemTapped));
  }
}
