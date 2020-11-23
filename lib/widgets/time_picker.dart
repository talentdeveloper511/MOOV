import 'dart:ffi';

import 'package:MOOV/models/post_model.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _startTime = TimeOfDay.now();
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
          color: Colors.amber[300],
          child: Text("Select Start Time"),
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
