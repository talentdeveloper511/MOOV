import 'dart:ffi';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:flutter/material.dart';

class TimePicker2 extends StatefulWidget {
  @override
  _TimePicker2State createState() => _TimePicker2State();
}

class _TimePicker2State extends State<TimePicker2> {
  TimeOfDay _endTime = TimeOfDay.now();
  TimeOfDay picked;
  String _selectedTime = "";

  Future<Void> _openTimePicker(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Text("Location ${widget.postModel.title}"),
        RaisedButton(
          color: TextThemes.ndBlue,
          child: Text(
            "Select End Time",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await _openTimePicker(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(7.5),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(_selectedTime),
              ],
            ),
          ),
        )
      ],
    );
  }
}
