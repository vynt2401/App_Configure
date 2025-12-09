import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:project_xla/screen/home/menu_bar/File/save_action.dart';
import 'package:project_xla/screen/home/menu_bar/File/upload_action.dart';
import 'package:project_xla/screen/home/menu_bar/edge_detection/canny.dart';
import 'package:project_xla/screen/home/menu_bar/edge_detection/prewitt.dart';
import 'package:project_xla/screen/home/menu_bar/edge_detection/robert.dart';
import 'package:project_xla/screen/home/menu_bar/edge_detection/sobel.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:project_xla/screen/provider/api/APIProvider.dart';

class EdgeDetection extends StatelessWidget {
  const EdgeDetection({super.key});

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
          Sobel(
            onPressedSobel: () async {
              // 1. Lấy Providers
              final imageState = context.read<ImageState>();
              final apiProvider = context.read<APIProvider>();
              // 2. Kiểm tra an toàn (tránh lỗi nếu chưa chọn ảnh)
              if (imageState.imageFile == null) {
                print("Chưa chọn ảnh!");
                return;
              }
              // 3. Gọi API
              final result = await apiProvider.applySobel(
                imageState.imageFile!, // File gốc
              );
              // 4. CẬP NHẬT UI (Phần bạn đang thiếu)
              if (result != null) {
                imageState.updateImageFromApi(result); // Đẩy ảnh mới vào ImageState để hiển thị
                print("Đã dò biên Sobel thành công!");
              }
            },
          ),
            Prewitt(onPressedPrewitt: () async {
              final imageState = context.read<ImageState>();
              final apiProvider = context.read<APIProvider>();

              if (imageState.imageFile == null) return;

              print("Đang dò biên Prewitt...");

              // Gọi hàm Prewitt
              final result = await apiProvider.applyPrewitt(
                  imageState.imageFile!
              );

              if (result != null) {
                imageState.updateImageFromApi(result);
                print("Xử lý Prewitt thành công!");
              }
            },
            ),
            Robert(onPressedRobert: () async {
              final imageState = context.read<ImageState>();
              final apiProvider = context.read<APIProvider>();

              if (imageState.imageFile == null) return;

              print("Đang dò biên Roberts...");

              final result = await apiProvider.applyRoberts(
                  imageState.imageFile!,
              );

              if (result != null) {
                imageState.updateImageFromApi(result);
                print("Xử lý Roberts thành công!");
              }
            },
            ),
            Canny(onPressedCanny: () async {
              final imageState = context.read<ImageState>();
              final apiProvider = context.read<APIProvider>();

              if (imageState.imageFile == null) return;

              print("Đang dò biên Canny...");

              // Gọi hàm Canny (Dùng ngưỡng chuẩn 100, 200)
              // Bạn có thể thay đổi số này để lấy nhiều biên hơn hoặc ít hơn
              final result = await apiProvider.applyCanny(
                  imageState.imageFile!,
                  t1: 100,
                  t2: 200
              );

              if (result != null) {
                imageState.updateImageFromApi(result);
                print("Xử lý Canny thành công!");
              }
            },
            ),
        ],
        child: Text('Edge Detection',style: TextStyle(color: Colors.white,),));
  }
}
