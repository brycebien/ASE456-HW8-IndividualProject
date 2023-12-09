import 'package:flutter/material.dart';

class DateInput extends StatefulWidget {
  final TextEditingController controller;
  final BuildContext context;
  final String hintText;

  const DateInput(
      {super.key,
      required this.controller,
      required this.context,
      required this.hintText});

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: widget.context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          widget.controller.text =
              selectedDate.toLocal().toString().split(' ')[0];
        }
      },
      decoration: InputDecoration(hintText: widget.hintText),
    );
  }
}
