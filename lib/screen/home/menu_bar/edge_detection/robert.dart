import 'package:flutter/material.dart';

class Robert extends StatelessWidget {
  final VoidCallback onPressedRobert;

  const Robert({super.key, required this.onPressedRobert});

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
      onPressed: onPressedRobert,
      child: const Text('Robert', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
