import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class KernelThree extends StatelessWidget {
  final VoidCallback onPressedMeanThree;

  const KernelThree({super.key, required this.onPressedMeanThree});

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
      onPressed: onPressedMeanThree,
      child: const Text('Kernel 3x3', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
