import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

Widget medicineCard({String name}) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.album),
          title: Text(name),
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: const Text('test'),
              onPressed: () {/* ... */},
            ),
            FlatButton(
              child: const Text('test 2'),
              onPressed: () {/* ... */},
            ),
          ],
        ),
      ],
    ),
  );
}
