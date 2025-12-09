// (Bỏ StatefulWidget đi, dùng StatelessWidget với Provider)
import 'package:flutter/material.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart'; // Thêm provider


class OverlapColor extends StatelessWidget {

  final List<Color> colorPalette = const [
    Colors.transparent, // "Tắt" hiệu ứng
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.black,
    Colors.white,
    Colors.indigoAccent,
    Colors.pink,
    Colors.redAccent,
    Colors.tealAccent
  ];
  const OverlapColor({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ImageState>();
    final Color? currentColor = provider.overlayColor; // Màu đang chọn
    // Đọc provider
    final bool _hasImage = (provider.imageFile != null);

    return ExpansionTile(
      title: Text('OverlapColor', style: TextStyle(color: Colors.white, fontSize: 12)),
      leading: Icon(Icons.color_lens_rounded, size: 15, color: Colors.white),
      trailing: SizedBox.shrink(),
      children: [
        // 3. GRIDVIEW ĐỂ CHỌN MÀU
        IgnorePointer(
          ignoring: !_hasImage,
          child: Opacity(
            opacity: _hasImage?1.0:0.5,
            child: Container(
              height: 70, // Chiều cao cho GridView (2 hàng)
              padding: const EdgeInsets.all( 5.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 5 màu trên 1 hàng
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: colorPalette.length,
                itemBuilder: (context, index) {
                  final Color color = colorPalette[index];
                  final bool isSelected = (color == currentColor);

                  return GestureDetector(
                    onTap: () {
                      // Cập nhật màu mới vào provider
                      context.read<ImageState>().setOverlayColor(color);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isSelected?Colors.grey.shade700:Colors.black,
                          width: isSelected?3:2,
                          style: BorderStyle.solid

                        )
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),


      ],
    );
  }
}

