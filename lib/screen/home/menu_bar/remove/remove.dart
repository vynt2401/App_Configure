import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/menu_bar/remove/remove_background.dart';
import 'package:project_xla/screen/home/menu_bar/remove/remove_foreground.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';

import '../../../provider/api/APIProvider.dart';

class Remove extends StatelessWidget {
  const Remove({super.key});

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
          Background(onPressedRemoveBack: () async {
            final imageState = context.read<ImageState>();
            final apiProvider = context.read<APIProvider>();

            if (imageState.imageFile == null) return;

            print("Đang xóa phông (việc này có thể mất vài giây)...");

            // Gọi API
            final result = await apiProvider.removeBackground(
                imageState.imageFile!,
            );

            if (result != null) {
              imageState.updateImageFromApi(result);
              print("Đã tách nền thành công!");
            }
          },
          ),
          Foreground(onPressedRemoveFore: () async {
            final imageState = context.read<ImageState>();
            final apiProvider = context.read<APIProvider>();

            if (imageState.imageFile == null) return;

            print("Đang xóa tiền cảnh...");

            final result = await apiProvider.removeForeground(
                imageState.imageFile!,
            );

            if (result != null) {
              imageState.updateImageFromApi(result);
              print("Đã xóa người, giữ nền!");
            }
          },
          ),
        ],
        child: Text('Remove',style: TextStyle(color: Colors.white,),));
  }
}
