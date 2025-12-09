import 'package:flutter/material.dart';

class SaveAction extends StatelessWidget {
  final VoidCallback onPressedSave;

  const SaveAction({super.key, required this.onPressedSave});

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
      onPressed: onPressedSave,
      child: const Text('Save as', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
