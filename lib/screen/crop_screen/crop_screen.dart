import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart'; // Đảm bảo đã import
import 'package:flutter/material.dart';

class CropScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const CropScreen({super.key, required this.imageBytes});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  final _cropController = CropController();

  // Biến trạng thái để hiện Loading
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Nút Check (Cắt)
          IconButton(
            icon: const Icon(Icons.check, color: Colors.greenAccent),
            // Nếu đang xử lý thì khóa nút lại
            onPressed: _isProcessing
                ? null
                : () {
              setState(() {
                _isProcessing = true;
              });

              // SỬA Ở ĐÂY: Thêm tham số format: ImageFormat.png
              _cropController.crop();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // LỚP DƯỚI: WIDGET CẮT ẢNH
          Crop(
            image: widget.imageBytes,
            controller: _cropController,

            // Cấu hình giao diện cắt
            baseColor: Colors.black,
            maskColor: Colors.black.withOpacity(0.5),
            interactive: true,

            // === SỰ KIỆN QUAN TRỌNG NHẤT ===
            // === SỬA ĐOẠN NÀY TRONG CROP SCREEN ===
            onCropped: (result) { // 'result' bây giờ là CropResult (Success/Failure)

              if (result is CropSuccess) {
                // 1. Nếu thành công, lấy bytes từ thuộc tính .croppedImage
                print("Đã cắt xong! Kích thước: ${result.croppedImage.length} bytes");

                if (mounted) {
                  // Trả về Uint8List cho màn hình trước
                  Navigator.of(context).pop(result.croppedImage);
                }
              } else if (result is CropFailure) {
                // 2. Nếu thất bại
                print("Lỗi cắt ảnh: ${result.cause}");
                setState(() => _isProcessing = false); // Tắt loading
                // Có thể hiện thông báo lỗi
              }
            },
          ),

          // LỚP TRÊN: VÒNG XOAY LOADING (Chỉ hiện khi bấm nút)
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}