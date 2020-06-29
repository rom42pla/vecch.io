import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/providers/database.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';
import 'package:flutter_test/flutter_test.dart';

class MedicinesPage extends StatefulWidget {
  @override
  _MedicinesPageState createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  List _medicinesWidgets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new StreamBuilder<Map>(
        stream: (() async* {
          while (true) {
            yield await DatabaseProvider().getMedicines();
            await Future<void>.delayed(Duration(seconds: 1));
          }
        })(), // a Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Press button to start');
            case ConnectionState.waiting:
              return new Text('Awaiting result...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                ///
                ///
                /// Medicines list
                ///
                ///
                Map _medicines = snapshot.data;
                _medicinesWidgets = new List<Widget>();
                _medicines.keys.forEach((_name) {
                  /// attributes initialization
                  DateTime _date =
                      DateTime.parse(_medicines[_name]["registration_date"]);
                  int _containerSlot = _medicines[_name]["container_slot"];
                  List _alarms = _medicines[_name]["alarms"];
     
                  /// widget definition
                  _medicinesWidgets.add(Card(
                      child: ExpansionTile(
                    title: Text(_name,
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.25)),
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Registration date'),
                        trailing: Text(_date.month.toString() +
                            "/" +
                            _date.day.toString() +
                            "/" +
                            _date.year.toString() +
                            " at " +
                            _date.hour.toString() +
                            ":" +
                            _date.minute.toString()),
                      ),
                      ListTile(
                          leading: Icon(Icons.radio),
                          title: Text('Slot on vecch.io device'),
                          trailing: Text(_containerSlot.toString())),
                      ListTile(
                        leading: Icon(Icons.alarm),
                        title: Text('Alarms'),
                        subtitle:
                            Text(_alarms.length.toString() + " alarms"),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              "DELETE",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  child: new AlertDialog(
                                    title: new Text("Delete medicine record?"),
                                    content: new Text(
                                        "Note that this will also delete all of your alarms."),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("I'VE CHANGED MY MIND"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("DELETE THE MEDICINE",
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          DatabaseProvider().deleteMedicine(
                                              medicineName: _name);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ));
                            },
                          ),
                          FlatButton(
                            child: Text("EDIT"),
                            onPressed: () {
                              Navigator.pushNamed(context, "/editMedicine",
                                  arguments: {
                                    "name": _name,
                                    "registration_date": _date,
                                    "container_slot": _containerSlot,
                                    "alarms": _alarms,
                                  });
                            },
                          )
                        ],
                      ),
                    ],
                  )));
                });

                ///
                /// no medicines card
                ///
                if (_medicinesWidgets.isEmpty) {
                  _medicinesWidgets.add(
                    ListTile(
                      subtitle: Text(
                          "No medicines registered yet!\nYou can add one by tapping the ➕ button on the bottom right of the page"),
                    ),
                  );
                }
                return ListView(children: _medicinesWidgets);
              }
          }
        },
      ),

      ///
      ///
      /// "add a medicine" button
      ///
      ///
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, child: AddMedicineDialog());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

///
///
/// "add a medicine" dialog
///
///
class AddMedicineDialog extends StatefulWidget {
  @override
  _AddMedicineDialogState createState() => new _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  String _medicineName = "";
  int _slot = 1;

  List _setAlarmAddMedicine = List<Widget>();
  String _newAlarmType = 'on a day of the week';
  DateTime _newAlarmOnceDay = DateTime.now();
  String _newAlarmWeekDay = 'monday';
  int _newAlarmMonthDay = 1;
  TimeOfDay _newAlarmHour = TimeOfDay(hour: TimeOfDay.now().hour, minute: 0);

  List <Widget> _alarmInAddMedicine(){

    List _setAlarmAddMedicine = List<Widget>();

    ///
    /// how many times
    _setAlarmAddMedicine.add(ListTile(
        title: Text("How many times?"),
        trailing: DropdownButton<String>(
          value: _newAlarmType,
          items: <String>[
            'just once',
            'on a day of the week',
            'on a day of the month'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_type) {
            setState(() {
              _newAlarmType = _type;
            });
          },
        )));

    ///
    /// time setting: just once
    ///
    switch (_newAlarmType) {
      case "just once":
        {
          /// day
          _setAlarmAddMedicine.add(ListTile(
            title: Text("On what day?"),
            trailing: OutlineButton(
              child: Text(_newAlarmOnceDay.month.toString() +
                  "/" +
                  _newAlarmOnceDay.day.toString() +
                  "/" +
                  _newAlarmOnceDay.year.toString()),
              onPressed: () async {
                DateTime _chosenDate = await showDatePicker(
                    context: context,
                    initialDate: _newAlarmOnceDay,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2));
                setState(() {
                  _newAlarmOnceDay =
                      (_chosenDate != null) ? _chosenDate : _newAlarmOnceDay;
                });
              },
            ),
          ));
          break;
        }
      case "on a day of the week":
        {
          _setAlarmAddMedicine.add(ListTile(
              title: Text("On which day?"),
              trailing: DropdownButton<String>(
                value: _newAlarmWeekDay,
                items: <String>[
                  'monday',
                  'tuesday',
                  'wednesday',
                  'thursday',
                  'friday',
                  'saturday',
                  'sunday'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_day) {
                  setState(() {
                    _newAlarmWeekDay = _day;
                  });
                },
              )));
          break;
        }
      case "on a day of the month":
        {
          {
            List<String> _monthDays = List<String>();
            new List<int>.generate(31, (i) => i + 1)
                .forEach((element) => _monthDays.add(element.toString()));
            _setAlarmAddMedicine.add(ListTile(
                title: Text("On which day?"),
                trailing: DropdownButton<String>(
                  value: _newAlarmMonthDay.toString(),
                  items: _monthDays.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_day) {
                    setState(() {
                      _newAlarmMonthDay = int.parse(_day);
                    });
                  },
                )));
            break;
          }
        }
    }

    /// hour
    _setAlarmAddMedicine.add(ListTile(
      title: Text("On which hour?"),
      trailing: OutlineButton(
        child: Text(_newAlarmHour.hour.toString().padLeft(2, "0") +
            ":" +
            _newAlarmHour.minute.toString().padLeft(2, "0")),
        onPressed: () async {
          TimeOfDay _chosenHour = await showTimePicker(
              context: context, initialTime: _newAlarmHour);
          setState(() {
            _newAlarmHour =
                (_chosenHour != null) ? _chosenHour : _newAlarmHour;
          });
        },
      ),
    ));

    return _setAlarmAddMedicine;
  }



  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(title: Text("Medicine infos")),
          ListTile(
            title: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: "medicine name",
              ),
              autocorrect: false,
              onChanged: (_newMedicineName) {
                setState(() {
                  if (_newMedicineName == null) {
                    _medicineName = "";
                  } else {
                    _medicineName = _newMedicineName;
                  }
                });
              },
            ),
            leading: Icon(Icons.edit),
          ),
          ListTile(
            leading: Icon(Icons.radio),
            title: Text("Slot on vecch.io device"),
            trailing: DropdownButton<String>(
              value: _slot.toString(),
              items: <String>['1', '2', '3', '4'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_newSlot) {
                setState(() {
                  _slot = int.parse(_newSlot);
                });
              },
            ),
          ),
          ..._alarmInAddMedicine(),
          ButtonBar(children: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: Text("ADD MEDICINE"),
                onPressed: (_medicineName != "")
                    ? () async {

                      Map _alarm;
                      switch (_newAlarmType) {
                        case "just once":
                          {
                            _alarm = {
                              "type": "once",
                              "day": _newAlarmOnceDay.year.toString() +
                                  "/" +
                                  _newAlarmOnceDay.month.toString().padLeft(2, "0") +
                                  "/" +
                                  _newAlarmOnceDay.day.toString().padLeft(2, "0"),
                              "hour": _newAlarmHour.hour.toString().padLeft(2, "0") +
                                  ":" +
                                  _newAlarmHour.minute.toString().padLeft(2, "0")
                            };
                            break;
                          }
                        case "on a day of the week":
                          {
                            _alarm = {
                              "type": "weekly",
                              "day": _newAlarmWeekDay,
                              "hour": _newAlarmHour.hour.toString().padLeft(2, "0") +
                                  ":" +
                                  _newAlarmHour.minute.toString().padLeft(2, "0")
                            };
                            break;
                          }
                        case "on a day of the month":
                          {
                            _alarm = {
                              "type": "monthly",
                              "day": _newAlarmMonthDay,
                              "hour": _newAlarmHour.hour.toString().padLeft(2, "0") +
                                  ":" +
                                  _newAlarmHour.minute.toString().padLeft(2, "0")
                            };
                          }
                          break;
                        }
            
                        await DatabaseProvider().addMedicine(
                            medicineName: _medicineName, slot: _slot, alarmMap: _alarm);
                        Navigator.pop(context);
                      }
                    : null),
          ]),
        ],
      ),
    );
  }
}

///
///
/// edit a medicine dialog
///
///
class EditMedicinePage extends StatefulWidget {
  @override
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  String _medicineName;
  int _containerSlot;
  DateTime _date;
  List _alarmTiles;

  List _alarms;
  String _newAlarmType = 'on a day of the week';
  DateTime _newAlarmOnceDay = DateTime.now();
  String _newAlarmWeekDay = 'monday';
  int _newAlarmMonthDay = 1;
  TimeOfDay _newAlarmHour = TimeOfDay(hour: TimeOfDay.now().hour, minute: 0);

  Widget build(BuildContext context) {
    /// parameters initialization
    Map arguments = ModalRoute.of(context).settings.arguments as Map;
    _medicineName = (_medicineName == null) ? arguments["name"] : _medicineName;
    _containerSlot =
        (_containerSlot == null) ? arguments["container_slot"] : _containerSlot;
    _date = (_date == null) ? arguments["registration_date"] : _date;
    _alarms = (_alarms == null) ? arguments["alarms"] : _alarms;

    List<Widget> widgets = new List<Widget>();

    ///
    ///
    /// registration date
    widgets.add(
      Card(
          child: ListTile(
              leading: Icon(Icons.today),
              title: Text("Registered on "),
              trailing: Text(_date.month.toString() +
                  "/" +
                  _date.day.toString() +
                  "/" +
                  _date.year.toString() +
                  " at " +
                  _date.hour.toString() +
                  ":" +
                  _date.minute.toString()))),
    );

    ///
    ///
    /// slot
    widgets.add(Card(
      child: ListTile(
          leading: Icon(Icons.radio),
          title: Text("Slot on vecch.io device"),
          trailing: DropdownButton<String>(
            value: _containerSlot.toString(),
            items: <String>['1', '2', '3', '4'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (_newSlot) {
              setState(() {
                _containerSlot = int.parse(_newSlot);
              });
            },
          )),
    ));

    ///
    /// active alarms (This is the list of current alarm into the database)
    ///
    _alarmTiles = new List<Widget>();
    for (int _alarmIndex = 0; _alarmIndex < _alarms.length; _alarmIndex++) {
      if (_alarmIndex == 0) {
        _alarmTiles.add(
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text("Alarms list"),
          ),
        );
      }
      String title = "", description = "";
      switch (_alarms[_alarmIndex]["type"]) {
        case "once":
          {
            title = "Once alarm";
            description = "On " +
                _alarms[_alarmIndex]["day"].toString() +
                " at " +
                _alarms[_alarmIndex]["hour"].toString();
            break;
          }
        case "weekly":
          {
            title = "Weekly alarm";
            description = "Each " +
                _alarms[_alarmIndex]["day"].toString() +
                " at " +
                _alarms[_alarmIndex]["hour"].toString();
            break;
          }
        case "monthly":
          {
            title = "Monthly alarm";
            description = "Each " +
                _alarms[_alarmIndex]["day"].toString() +
                "° of the month at " +
                _alarms[_alarmIndex]["hour"].toString();
            break;
          }
      }
      _alarmTiles.add(Opacity(opacity: 1,
          child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: FlatButton(
          child: Icon(Icons.delete),
          onPressed: () async {
            await DatabaseProvider()
                .deleteAlarm(medicineName: _medicineName, index: _alarmIndex);
            setState(() {
              _alarms.remove(_alarms[_alarmIndex]);
            });
          },
        ),
      )));
    }

    if (_alarmTiles.isNotEmpty) {
      widgets.add(Card(child: Column(children: _alarmTiles)));
    }

    ///
    /// add alarms
    ///
    List _baseTiles = List<Widget>();

    ///
    /// how many times
    _baseTiles.add(ListTile(
        title: Text("How many times?"),
        trailing: DropdownButton<String>(
          value: _newAlarmType,
          items: <String>[
            'just once',
            'on a day of the week',
            'on a day of the month'
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_type) {
            setState(() {
              _newAlarmType = _type;
            });
          },
        )));

    ///
    /// time setting: just once
    ///
    switch (_newAlarmType) {
      case "just once":
        {
          /// day
          _baseTiles.add(ListTile(
            title: Text("On what day?"),
            trailing: OutlineButton(
              child: Text(_newAlarmOnceDay.month.toString() +
                  "/" +
                  _newAlarmOnceDay.day.toString() +
                  "/" +
                  _newAlarmOnceDay.year.toString()),
              onPressed: () async {
                DateTime _chosenDate = await showDatePicker(
                    context: context,
                    initialDate: _newAlarmOnceDay,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 2));
                setState(() {
                  _newAlarmOnceDay =
                      (_chosenDate != null) ? _chosenDate : _newAlarmOnceDay;
                });
              },
            ),
          ));
          break;
        }
      case "on a day of the week":
        {
          _baseTiles.add(ListTile(
              title: Text("On which day?"),
              trailing: DropdownButton<String>(
                value: _newAlarmWeekDay,
                items: <String>[
                  'monday',
                  'tuesday',
                  'wednesday',
                  'thursday',
                  'friday',
                  'saturday',
                  'sunday'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_day) {
                  setState(() {
                    _newAlarmWeekDay = _day;
                  });
                },
              )));
          break;
        }
      case "on a day of the month":
        {
          {
            List<String> _monthDays = List<String>();
            new List<int>.generate(31, (i) => i + 1)
                .forEach((element) => _monthDays.add(element.toString()));
            _baseTiles.add(ListTile(
                title: Text("On which day?"),
                trailing: DropdownButton<String>(
                  value: _newAlarmMonthDay.toString(),
                  items: _monthDays.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_day) {
                    setState(() {
                      _newAlarmMonthDay = int.parse(_day);
                    });
                  },
                )));
            break;
          }
        }
    }

    /// hour
    _baseTiles.add(ListTile(
      title: Text("On which hour?"),
      trailing: OutlineButton(
        child: Text(_newAlarmHour.hour.toString().padLeft(2, "0") +
            ":" +
            _newAlarmHour.minute.toString().padLeft(2, "0")),
        onPressed: () async {
          TimeOfDay _chosenHour = await showTimePicker(
              context: context, initialTime: _newAlarmHour);
          setState(() {
            _newAlarmHour =
                (_chosenHour != null) ? _chosenHour : _newAlarmHour;
          });
        },
      ),
    ));

    /// "add" button
    _baseTiles.add(ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text("ADD ALARM"),
          onPressed: () async {
            Map _alarm;
            switch (_newAlarmType) {
              case "just once":
                {
                  _alarm = {
                    "type": "once",
                    "day": _newAlarmOnceDay.year.toString() +
                        "/" +
                        _newAlarmOnceDay.month.toString().padLeft(2, "0") +
                        "/" +
                        _newAlarmOnceDay.day.toString().padLeft(2, "0"),
                    "hour": _newAlarmHour.hour.toString().padLeft(2, "0") +
                        ":" +
                        _newAlarmHour.minute.toString().padLeft(2, "0")
                  };
                  break;
                }
              case "on a day of the week":
                {
                  _alarm = {
                    "type": "weekly",
                    "day": _newAlarmWeekDay,
                    "hour": _newAlarmHour.hour.toString().padLeft(2, "0") +
                        ":" +
                        _newAlarmHour.minute.toString().padLeft(2, "0")
                  };
                  break;
                }
              case "on a day of the month":
                {
                  _alarm = {
                    "type": "monthly",
                    "day": _newAlarmMonthDay,
                    "hour": _newAlarmHour.hour.toString().padLeft(2, "0") +
                        ":" +
                        _newAlarmHour.minute.toString().padLeft(2, "0")
                  };
                }
                break;
            }

            await DatabaseProvider()
                .addAlarm(medicineName: _medicineName, alarmMap: _alarm);
            setState(() {
              _alarms.add(_alarm);
            });
          },
        )
      ],
    ));

    ///
    /// add to widgets
    ///
    widgets.add(Card(
        child: ExpansionTile(
      leading: Icon(Icons.alarm_add),
      title: Text("Tap here to add an alarm",
          style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.add_circle),
      children: _baseTiles,
    )));

    return Scaffold(
        appBar: AppBar(
          title: Text(_medicineName),
          backgroundColor: Colors.transparent,
        ),
        body: ListView(children: widgets));
  }
}
