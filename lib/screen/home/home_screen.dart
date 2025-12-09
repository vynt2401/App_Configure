import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/Adjustment/range_adjustment.dart';
import 'package:project_xla/screen/home/menu_bar/menu_bar.dart';
import 'package:project_xla/screen/home/range_image/range_image.dart';
import 'package:project_xla/screen/home/tool/tools.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: MenuBarr()
      ),
      body: Row(

        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ///TOOL
          Tools(),
          ///Background img
          RangeImage(),
          ///Property
          Expanded(
            child: RangeAdjustment(),
          ),
        ],
      ),


    );
  }
}
