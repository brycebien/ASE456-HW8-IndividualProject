import 'package:flutter/material.dart';

class ShowSnackBar {
  final String content;
  final int duration;
  final BuildContext context;

  const ShowSnackBar(
      {required this.content, required this.duration, required this.context});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
