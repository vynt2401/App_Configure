import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/tool/tool_items.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color:  Color(0xFF222222),
        border: BoxBorder.fromLTRB(top: BorderSide(width: 1,color: Colors.black45))
      ),
      child: ToolItems(),
    );
  }
}
