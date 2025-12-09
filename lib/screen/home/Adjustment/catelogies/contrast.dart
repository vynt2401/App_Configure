// contrast_slider.dart (File mới)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';

class Contrast extends StatelessWidget {
  const Contrast({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. "LẮNG NGHE" (watch) để lấy giá trị hiện tại
    final double currentContrast = context.watch<ImageState>().contrast;

    // 2. "RA LỆNH" (read) để gọi hàm
    final imageState = context.read<ImageState>();
    final bool _hasImage = (imageState.imageFile != null);

    return ExpansionTile(
      title: Text('Contrast', style: TextStyle(color: Colors.white, fontSize: 12)),
      leading: Icon(CupertinoIcons.circle_righthalf_fill, size: 15, color: Colors.white),
      trailing: SizedBox.shrink(),
      children: [
        IgnorePointer(
          ignoring: !_hasImage,
          child: Opacity(
            opacity: _hasImage?1.0:0.5,
            child: Slider(
              // 3. Dùng giá trị TỪ PROVIDER
              value: currentContrast,

              onChanged: (newValue) {
                // 4. GỌI HÀM CỦA PROVIDER
                imageState.setContrast(newValue);
              },

              min: 0.1, // 0% (xám)
              max: 2.0, // 200% (tương phản cao)
              label: currentContrast.toStringAsFixed(1), // (Tùy chọn)
            ),
          ),
        ),
      ],
    );
  }
}