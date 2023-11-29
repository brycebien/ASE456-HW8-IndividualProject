import 'package:flutter/material.dart';

class TaskInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const TaskInput(
      {super.key, required this.controller, required this.hintText});

  @override
  _TaskInputState createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(hintText: widget.hintText),
    );
  }
}
