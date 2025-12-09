import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/Adjustment/catelogies/blur.dart';
import 'package:project_xla/screen/home/Adjustment/catelogies/brightness.dart';
import 'package:project_xla/screen/home/Adjustment/catelogies/contrast.dart';
import 'package:project_xla/screen/home/Adjustment/catelogies/overlapcolor.dart';
import 'package:provider/provider.dart';

import '../../provider/upload_images/image_state.dart';

class RangeAdjustment extends StatefulWidget {
  const RangeAdjustment({super.key});


  @override
  State<RangeAdjustment> createState() => _RangeAdjustmentState();
}

class _RangeAdjustmentState extends State<RangeAdjustment> {
  double _zoom = 0.5;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(top: BorderSide(width: 1,color: Colors.black45)),
        color:  Color(0xFF222222),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height:30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: BoxBorder.fromLTRB(bottom: BorderSide(width: 1,color: Colors.black45)),
                    color:  Color(0xFF222222),
                  ),
                  child: Text('Adjustments',style: TextStyle(color: Colors.white,fontSize: 12),),
                ),
                Brightness(),
                Contrast(),
                Blur(),
                OverlapColor(),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  context.read<ImageState>().clearAdjustments();
                }, child: Text('Reset'))

              ],
            ),

            ]
        ),
      )
    );
  }
}
