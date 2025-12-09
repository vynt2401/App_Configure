import 'package:flutter/material.dart';

class RgbToGray extends StatelessWidget {
  final VoidCallback onPressedRGBtoGray;
  const RgbToGray({super.key, required this.onPressedRGBtoGray});

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
      onPressed: onPressedRGBtoGray,
      child: const Text('RGB to Gray', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
