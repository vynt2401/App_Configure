import 'package:flutter/material.dart';

class UploadAction extends StatelessWidget {
  final VoidCallback onUpload;

  const UploadAction({super.key, required this.onUpload});

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
      onPressed: onUpload,
      child: const Text('Open', style: TextStyle(color: Colors.white54, fontSize: 12)),
    );
  }
}
