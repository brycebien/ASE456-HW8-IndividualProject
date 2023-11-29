import 'package:flutter/material.dart';

class TagInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const TagInput({super.key, required this.controller, required this.hintText});

  @override
  _TagInputState createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(hintText: widget.hintText),
    );
  }
}
