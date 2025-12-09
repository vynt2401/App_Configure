import 'package:flutter/material.dart';

class Canny extends StatelessWidget {
  final VoidCallback onPressedCanny;

  const Canny({super.key, required this.onPressedCanny});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.grey.shade700;
          }
          return Colors.black;
        }),
      ),
      onPressed: onPressedCanny,
      child: const Text('Canny', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
