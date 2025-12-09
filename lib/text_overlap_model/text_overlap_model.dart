import 'package:flutter/material.dart';

class TextOverlay {
  String id;
  String text;
  Offset position; // Vị trí x, y
  Color color;
  double fontSize;

  TextOverlay({
    required this.id,
    required this.text,
    this.position = const Offset(100, 100), // Vị trí mặc định
    this.color = Colors.white,
    this.fontSize = 20.0,
  });
}