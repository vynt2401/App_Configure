import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/menu_bar/Convert/RGB_to_Binary.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data'; // Để dùng Uint8List

// Import các file của bạn
import 'package:project_xla/screen/home/menu_bar/Convert/RGB_to_Gray.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';

import '../../../provider/api/APIProvider.dart'; // <--- Nhớ import file này

class Convert extends StatelessWidget {
  const Convert({super.key});

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey.withOpacity(0.2); // Flutter cũ dùng withOpacity, mới dùng withValues
            }
            return Colors.transparent;
          }),
        ),
        menuChildren: [
          // === NÚT CON: RGB TO GRAY ===
          RgbToGray(
              onPressedRGBtoGray: () async { // <--- 1. Thêm 'async'
                // A. Lấy 2 Provider
                final imageState = context.read<ImageState>();
                final apiProvider = context.read<APIProvider>();

                // B. Kiểm tra có ảnh chưa
                if (imageState.imageFile == null) {
                  print("Chưa có ảnh!");
                  return;
                }

                // C. Gọi API (Hàm này nằm bên APIProvider)
                // Nó gửi ảnh đi và chờ nhận về 'bytes' của ảnh xám
                final Uint8List? resultBytes = await apiProvider.convertToGrayscale(imageState.imageFile!);

                // D. Nếu thành công, cập nhật ngược lại vào ImageState
                if (resultBytes != null) {
                  // Hàm này nằm bên ImageState, dùng để hiển thị ảnh mới
                  imageState.updateImageFromApi(resultBytes);

                  print("Đã chuyển đổi xong!");
                }
              }
          ),
          //
          RgbToBinary(onPressedRGBtoBinary: () async {
            final imageState = context.read<ImageState>();
            final apiProvider = context.read<APIProvider>();

            if (imageState.imageFile == null) return;

            print("Đang gọi API Binary thủ công...");
            final Uint8List? result = await apiProvider.convertToBinary(
                imageState.imageFile!);

            if (result != null) {
              print("Thành công!");
              imageState.updateImageFromApi(result);
            }
          }
          )
        ],
        child: const Text('Convert', style: TextStyle(color: Colors.white)));
  }
}