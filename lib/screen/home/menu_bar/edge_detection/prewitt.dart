import 'package:flutter/material.dart';

class Prewitt extends StatelessWidget {
  final VoidCallback onPressedPrewitt;

  const Prewitt({super.key, required this.onPressedPrewitt});

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
      onPressed: onPressedPrewitt,
      child: const Text('Prewitt', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
