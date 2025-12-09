import 'package:flutter/material.dart';

class Gaussion extends StatelessWidget {
  final VoidCallback onPressedGaussion;

  const Gaussion({super.key, required this.onPressedGaussion});

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
      onPressed: onPressedGaussion,
      child: const Text('Add more Gaussian noise', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
