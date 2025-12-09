import 'package:flutter/material.dart';

class RgbToBinary extends StatelessWidget {
  final VoidCallback onPressedRGBtoBinary;
  const RgbToBinary({super.key, required this.onPressedRGBtoBinary});

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
      onPressed: onPressedRGBtoBinary,
      child: const Text('RGB to Binary', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
