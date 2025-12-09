import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/menu_bar/Convert/convert.dart';
import 'package:project_xla/screen/home/menu_bar/File/file.dart';
import 'package:project_xla/screen/home/menu_bar/edge_detection/edge_detection.dart';
import 'package:project_xla/screen/home/menu_bar/noise/noise.dart';
import 'package:project_xla/screen/home/menu_bar/remove/remove.dart';

class MenuBarr extends StatefulWidget {
  const MenuBarr({super.key});

  @override
  State<MenuBarr> createState() => _MenuBarrState();
}

class _MenuBarrState extends State<MenuBarr> {
  @override
  Widget build(BuildContext context) {
    return MenuBar(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shadowColor: WidgetStatePropertyAll(Colors.transparent)
        ),
        children: [
            Upload(),
            Convert(),
            EdgeDetection(),
            Noise(),
            Remove(),
        ]
    );
  }
}

