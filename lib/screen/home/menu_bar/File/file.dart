import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/menu_bar/File/save_action.dart';
import 'package:project_xla/screen/home/menu_bar/File/upload_action.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey.withValues(alpha: 0.2);
            }
            return Colors.transparent;
          }
          ),
        ),
        menuChildren: [
          // gọi provider ở ngoài File
            UploadAction(onUpload: () {
               context.read<ImageState>().pickImage();
            },),

          //
          SaveAction(
            onPressedSave: () {
              context.read<ImageState>().triggerSave();
            }
          ),
        ],
        child: Text('File',style: TextStyle(color: Colors.white,),));
  }
}
