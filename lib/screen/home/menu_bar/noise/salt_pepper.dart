import 'package:flutter/material.dart';

class SaltPepper extends StatelessWidget {
  final VoidCallback onPressedsaltPepper;

  const SaltPepper({super.key, required this.onPressedsaltPepper});

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
      onPressed: onPressedsaltPepper,
      child: const Text('Add more salt and pepper noise', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
