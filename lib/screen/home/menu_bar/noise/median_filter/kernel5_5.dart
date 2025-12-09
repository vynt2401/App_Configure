import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class KernelFiveMedian extends StatelessWidget {
  final VoidCallback onPressedMedianFive;

  const KernelFiveMedian({super.key, required this.onPressedMedianFive});

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
      onPressed: onPressedMedianFive,
      child: const Text('Kernel 5x5', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
