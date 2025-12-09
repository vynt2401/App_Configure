import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class KernelFive extends StatelessWidget {
  final VoidCallback onPressedMeanFive;

  const KernelFive({super.key, required this.onPressedMeanFive});

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
      onPressed: onPressedMeanFive,
      child: const Text('Kernel 5x5', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
