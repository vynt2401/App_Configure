import 'package:flutter/material.dart';

class Foreground extends StatelessWidget {
  final VoidCallback onPressedRemoveFore;

  const Foreground({super.key, required this.onPressedRemoveFore});

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
      onPressed: onPressedRemoveFore,
      child: const Text('Remove Foreground', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
