import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/pages/home.dart';
import 'package:vecchio/pages/login.dart';
import 'package:vecchio/providers/database.dart';
import 'package:unicorndial/unicorndial.dart';

Widget loginButton(
    {var newPage,
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController passwordController}) {
  return FlatButton(
    onPressed: () async {
      String username = usernameController.text.trim().toLowerCase();
      String password = passwordController.text.trim().toLowerCase();
      if (newPage != null) {
        // check if this username or password exists
        if (username != "test") {
          // TODO implement database check for username
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Username not registered"),
          ));
        } else {
          // check if password is correct
          if (password != "test") {
            // TODO implement database check for password
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Wrong password"),
            ));
          }
          // if everything is correct, boot the homepage
          else {
            DatabaseProvider dbProvider = new DatabaseProvider();
            dbProvider.saveUserCredentials(username);
            print("Logged $username with password $password");
            FocusScope.of(context).unfocus();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        }
      }
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

Widget logoutButton({BuildContext context}) {
  return FlatButton(
    onPressed: () {
      DatabaseProvider dbProvider = new DatabaseProvider();
      dbProvider.clearDatabase();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
    child: Text("LOGOUT", style: TextStyle(color: Colors.red)),
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

Widget addMedicineButton({BuildContext context, bool miniButtons = true}) {
  List<UnicornButton> children = [];
  children.add(UnicornButton(
      hasLabel: true,
      labelText: "Medicine to take once",
      currentButton: FloatingActionButton(
        heroTag: "once",
        backgroundColor: Colors.green[500],
        mini: miniButtons,
        child: Icon(Icons.play_arrow),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => OnceMedicineDialog());
        },
      )));
  children.add(UnicornButton(
      hasLabel: true,
      labelText: "Medicine to take weekly",
      currentButton: FloatingActionButton(
        heroTag: "weekly",
        backgroundColor: Colors.green[500],
        mini: miniButtons,
        child: Icon(Icons.replay),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => OnceMedicineDialog());
        },
      )));
  children.add(UnicornButton(
      hasLabel: true,
      labelText: "Medicine to take monthly",
      currentButton: FloatingActionButton(
        heroTag: "monthly",
        backgroundColor: Colors.green[500],
        mini: miniButtons,
        child: Icon(Icons.replay_30),
        onPressed: () => print("ok"),
      )));

  return UnicornDialer(
      parentButtonBackground: Colors.green,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: children);
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
