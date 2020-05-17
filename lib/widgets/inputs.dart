import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/pages/home.dart';
import 'package:vecchio/pages/login.dart';
import 'package:vecchio/providers/database.dart';

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
        icon: Icon(Icons.local_hospital),
        title: Text('Medicines'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Settings'),
      ),
    ],
    currentIndex: view,
    //selectedItemColor: Colors.brown,
    onTap: onTap,
  );
}

class OnceMedicineDialog extends StatefulWidget {
  @override
  _OnceMedicineDialogState createState() => new _OnceMedicineDialogState();
}

class _OnceMedicineDialogState extends State<OnceMedicineDialog> {
  String _therapyName = "";
  DateTime _date = DateTime.now();
  TimeOfDay _hour = TimeOfDay(hour: TimeOfDay.now().hour, minute: 0);
  bool _okEnabled = false;

  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            child: ListTile(
              title: TextFormField(
                decoration: InputDecoration(
                  hintText: "Type here to edit",
                  isDense: true,
                  border: OutlineInputBorder(),
                  labelText: "Therapy name",
                ),
                autocorrect: false,
                onChanged: (_newTherapyName) {
                  setState(() {
                    if (_newTherapyName == null) {
                      _therapyName = "";
                    } else {
                      _therapyName = _newTherapyName;
                    }
                    _okEnabled = (_therapyName == "") ? false : true;
                  });
                },
              ),
              leading: Icon(Icons.edit),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Date"),
              subtitle: Text(
                _date.month.toString() +
                    "/" +
                    _date.day.toString() +
                    "/" +
                    _date.year.toString(),
              ),
              leading: Icon(Icons.calendar_today),
              trailing: FlatButton(
                onPressed: () async {
                  DateTime _selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(_date.year),
                      lastDate: DateTime(_date.year + 2));
                  if (_selectedDate != null) {
                    setState(() {
                      _date = _selectedDate;
                    });
                  }
                },
                child: Text("CHANGE"),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Hour"),
              subtitle: Text(_hour.hour.toString().padLeft(2, '0') +
                  ":" +
                  _hour.minute.toString().padLeft(2, '0')),
              leading: Icon(Icons.schedule),
              trailing: FlatButton(
                onPressed: () async {
                  TimeOfDay _selectedHour = await showTimePicker(
                      context: context, initialTime: _hour);
                  if (_selectedHour != null) {
                    setState(() {
                      _hour = _selectedHour;
                    });
                  }
                },
                child: Text("CHANGE"),
              ),
            ),
          ),
          ButtonBar(children: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: Text("OK"),
                onPressed: !_okEnabled
                    ? null
                    : () {
                        // TODO add therapy to storage
                        print("$_therapyName, $_date, $_hour");
                        Navigator.pop(context);
                      }),
          ]),
        ],
      ),
    );
  }
}

Widget onceMedicineDialog({BuildContext context}) {
  DateTime _date = DateTime.now();
  TextEditingController _dateController = new TextEditingController();

  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text("Date"),
            subtitle: Text(
              _date.month.toString() +
                  "/" +
                  _date.day.toString() +
                  "/" +
                  _date.year.toString(),
            ),
            leading: Icon(Icons.calendar_today),
            trailing: FlatButton(
              onPressed: () async {
                _date = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(_date.year),
                    lastDate: DateTime(_date.year + 2));
              },
              child: Text("CHANGE"),
            ),
          ),
        )
      ],
    ),
  );
}
