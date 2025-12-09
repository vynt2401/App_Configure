import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class KernelGassianSeven extends StatelessWidget {
  final VoidCallback onPressedGaussionSeven;

  const KernelGassianSeven({super.key, required this.onPressedGaussionSeven});

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
      onPressed: onPressedGaussionSeven,
      child: const Text('Kernel 7x7', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
