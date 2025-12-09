import 'package:flutter/material.dart';
import 'package:project_xla/text_overlap_model/text_overlap_model.dart';
import 'package:provider/provider.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart'; // Import đúng đường dẫn

class DraggableTextWidget extends StatelessWidget {
  final TextOverlay textItem;

  const DraggableTextWidget({super.key, required this.textItem});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: textItem.position.dx,
      top: textItem.position.dy,
      child: GestureDetector(
        // Xử lý kéo thả
        onPanUpdate: (details) {
          // Tính toán vị trí mới
          // Lấy vị trí cũ + khoảng cách di chuyển (delta)
          final newPos = Offset(
            textItem.position.dx + details.delta.dx,
            textItem.position.dy + details.delta.dy,
          );
          // Cập nhật vào Provider
          context.read<ImageState>().updateTextPosition(textItem.id, newPos);
        },
        // (Tùy chọn) Nhấn đúp để xóa
        onDoubleTap: () {
          context.read<ImageState>().removeText(textItem.id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            // Thêm nền mờ nhẹ để chữ dễ đọc hơn trên ảnh nhiễu
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            textItem.text,
            style: TextStyle(
              color: textItem.color,
              fontSize: textItem.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}