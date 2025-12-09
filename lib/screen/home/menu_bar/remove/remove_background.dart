import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final VoidCallback onPressedRemoveBack;

  const Background({super.key, required this.onPressedRemoveBack});

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
      onPressed: onPressedRemoveBack,
      child: const Text('Remove Background', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
