import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:project_xla/screen/provider/upload_images/image_state.dart'; // <-- 2. IMPORT BỘ NÃO

// 3. Chuyển nó thành STATELESS WIDGET (vì không cần setState nữa)
class Blur extends StatelessWidget {
  const Blur({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. "LẮNG NGHE" (watch) để lấy giá trị hiện tại
    final double currentBlur = context.watch<ImageState>().blur;

    // 5. "RA LỆNH" (read) để gọi hàm
    final imageState = context.read<ImageState>();
    final bool _hasImage = (imageState.imageFile != null);

    return ExpansionTile(
      title: Text('Blur', style: TextStyle(color: Colors.white, fontSize: 12)),
      leading: Icon(Icons.blur_circular_outlined, size: 15, color: Colors.white),
      trailing: SizedBox.shrink(),

      children: [
        IgnorePointer(
          ignoring: !_hasImage,
          child: Opacity(
            opacity: _hasImage?1.0:0.5,
            child: Slider(
              // 6. Dùng giá trị TỪ PROVIDER
              value: currentBlur,

              onChanged: (newValue) {
                // 7. GỌI HÀM CỦA PROVIDER (thay vì setState)
                imageState.setBlur(newValue);
              },

              // 8.
              min: 0,
              max: 10,
              divisions: 20, // (Tùy chọn)
              label: currentBlur.toStringAsFixed(1), // (Tùy chọn)
            ),
          ),
        ),
      ],
    );
  }
}