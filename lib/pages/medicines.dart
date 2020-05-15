import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

class MedicinesPage extends StatefulWidget {
  @override
  _MedicinesPageState createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[medicineCard(name: "Tachipirina supposta 100g")],
      ),
      floatingActionButton: addMedicineButton(context: context),
    );
  }
}
