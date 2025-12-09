import 'package:flutter/material.dart';

class Sobel extends StatelessWidget {
  final VoidCallback onPressedSobel;

  const Sobel({super.key, required this.onPressedSobel});

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
      onPressed: onPressedSobel,
      child: const Text('Sobel', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
