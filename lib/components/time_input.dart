import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeInput extends StatefulWidget {
  final TextEditingController controller;
  final BuildContext context;
  final String hintText;

  const TimeInput(
      {super.key,
      required this.controller,
      required this.context,
      required this.hintText});

  @override
  _TimeInputState createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$'),
        ),
      ],
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (selectedTime != null) {
          widget.controller.text = selectedTime.format(widget.context);
        }
      },
      decoration: InputDecoration(hintText: widget.hintText),
    );
  }
}
