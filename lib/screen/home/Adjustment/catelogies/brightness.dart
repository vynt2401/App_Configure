import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORT PROVIDER
import 'package:project_xla/screen/provider/upload_images/image_state.dart'; // <-- 2. IMPORT BỘ NÃO

// 3. Chuyển nó thành STATELESS WIDGET (vì không cần setState nữa)
class Brightness extends StatelessWidget {
  const Brightness({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. "LẮNG NGHE" (watch) để lấy giá trị hiện tại
    final double currentBrightness = context.watch<ImageState>().brightness;

    // 5. "RA LỆNH" (read) để gọi hàm
    final imageState = context.read<ImageState>();
    final bool _hasImage = (imageState.imageFile != null);


    return ExpansionTile(
      title: Text('Brightness', style: TextStyle(color: Colors.white, fontSize: 12)),
      leading: Icon(CupertinoIcons.brightness, size: 15, color: Colors.white),
      trailing: SizedBox.shrink(),
      children: [
        IgnorePointer(
          ignoring: !_hasImage, // true = disable
          child: Opacity(
            opacity:  _hasImage ? 1.0 : 0.5, // làm mờ vùng nếu bị disable
            child: Slider(
              // 6. Dùng giá trị TỪ PROVIDER
              value: currentBrightness,

              onChanged: (newValue) {
                // 7. GỌI HÀM CỦA PROVIDER (thay vì setState)
                imageState.setBrightness(newValue);
              },

              // 8. Sửa lại min/max cho đúng (từ -1 đến 1)
              min: -0.3,
              max: 0.5,
              label: currentBrightness.toStringAsFixed(1), // (Tùy chọn)
            ),
          ),
        ),
      ],
    );
  }
}