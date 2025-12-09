import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class KernelThreeGaussian extends StatelessWidget {
  final VoidCallback onPressedGaussianThree;

  const KernelThreeGaussian({super.key, required this.onPressedGaussianThree});

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
      onPressed: onPressedGaussianThree,
      child: const Text('Kernel 3x3', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
