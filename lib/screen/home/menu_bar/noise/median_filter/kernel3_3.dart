import 'package:flutter/material.dart';


class KernelThreeMedian extends StatelessWidget {
  final VoidCallback onPressedMedianThree;

  const KernelThreeMedian({super.key, required this.onPressedMedianThree});

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
      onPressed: onPressedMedianThree,
      child: const Text('Kernel 3x3', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
