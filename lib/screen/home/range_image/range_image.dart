import 'dart:io';
import 'dart:ui' as ui; // Cần thiết cho RepaintBoundary
import 'dart:typed_data'; // Cần thiết cho Uint8List
import 'package:file_picker/file_picker.dart'; // Cần thiết để lưu file
import 'package:flutter/material.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

import '../../../text_overlap_model/draggable_text.dart';

class RangeImage extends StatefulWidget {
  const RangeImage({super.key});

  @override
  State<RangeImage> createState() => _RangeImageState();
}

class _RangeImageState extends State<RangeImage> {
  // Key để chụp ảnh màn hình (dùng cho ảnh chỉnh sửa thủ công)
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Đăng ký hàm saveImageSmart vào Provider ngay khi Widget được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ImageState>().registerSaveCallback(saveImageSmart);
    });
  }

  // --- HÀM LƯU ẢNH THÔNG MINH (HOÀN CHỈNH) ---
  Future<void> saveImageSmart() async {
    // Kiểm tra xem có ảnh để lưu không (dù là ảnh gốc hay ảnh API)
    final provider = context.read<ImageState>();
    if (provider.imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có ảnh để lưu!')),
      );
      return;
    }

    print("📸 Bắt đầu chụp màn hình (RepaintBoundary)...");

    try {
      RenderRepaintBoundary? boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        print("Lỗi: Không tìm thấy Key RepaintBoundary (UI chưa vẽ xong?)");
        return;
      }

      // (Tùy chọn) Đợi nếu widget đang vẽ dở để tránh lỗi ảnh đen
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
      }

      // 2. Chụp ảnh (pixelRatio 3.0 để ảnh nét, chất lượng cao)

      ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      // 3. Chuyển đổi sang dữ liệu PNG (Bytes)


      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);



      if (byteData == null) {
        throw Exception("Không thể mã hóa ảnh sang PNG");
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();




      // 4. Mở hộp thoại chọn nơi lưu (File Picker)
      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save as',
        fileName: 'image.png',
        type: FileType.image,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      );

      if (savePath == null) {
        print("Người dùng đã hủy lưu.");
        return;
      }

      // 5. Ghi file xuống ổ cứng


      final File file = File(savePath);
      await file.writeAsBytes(pngBytes);

      print("Đã lưu thành công tại: $savePath");

      // 6. Thông báo cho người dùng
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved successfully!')));
      }

    } catch (e) {
      print("Lỗi khi lưu ảnh: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi lưu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 500, // Chiều cao cố định để BoxFit.fill hoạt động
      color: Colors.black38,
      alignment: Alignment.center,
      child: Consumer<ImageState>(
        builder: (context, provider, child) {
          if (provider.imageFile == null) {
            // Giao diện khi chưa có ảnh
            return Center(
              child: InkWell(
                hoverColor: Colors.blue.withOpacity(0.2),
                splashColor: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  context.read<ImageState>().pickImage();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload_outlined, color: Colors.white, size: 30),
                      SizedBox(height: 10),
                      Text('Upload image',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // ===========================================================
            // LAYER 1: XÂY DỰNG WIDGET ẢNH CHỈNH SỬA (THỦ CÔNG)
            // ===========================================================

            // 1. Ảnh gốc + Transform (Xoay, Lật, Fit)
            Widget imageWidget = RotatedBox(
              quarterTurns: provider.degrees,
              child: Transform.scale(
                scaleX: provider.isFlipHorizontal ? -1 : 1,
                scaleY: provider.isFlipVertical ? -1 : 1,
                child: Image.file(
                  provider.imageFile!,
                  fit: provider.boxFit,
                  width: provider.boxFit == BoxFit.fill ? double.infinity : null,
                  height: provider.boxFit == BoxFit.fill ? double.infinity : null,
                ),
              ),
            );

            // 2. Filter: Độ sáng
            imageWidget = ColorFiltered(
              colorFilter: ColorFilter.matrix([
                1, 0, 0, 0, provider.brightness * 255,
                0, 1, 0, 0, provider.brightness * 255,
                0, 0, 1, 0, provider.brightness * 255,
                0, 0, 0, 1, 0,
              ]),
              child: imageWidget,
            );

            // 3. Filter: Tương phản
            final double c = provider.contrast;
            final double t = (1.0 - c) * 0.5 * 255;
            imageWidget = ColorFiltered(
              colorFilter: ColorFilter.matrix([
                c, 0, 0, 0, t,
                0, c, 0, 0, t,
                0, 0, c, 0, t,
                0, 0, 0, 1, 0,
              ]),
              child: imageWidget,
            );

            // 4. Filter: Blur
            final double blurValue = provider.blur;
            if (blurValue > 0.0) {
              imageWidget = ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: blurValue,
                  sigmaY: blurValue,
                ),
                child: imageWidget,
              );
            }

            // 5. Filter: Overlay Color
            final Color? selectedColor = provider.overlayColor;
            if (selectedColor != Colors.transparent) {
              imageWidget = ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selectedColor!.withOpacity(0.5),
                  BlendMode.srcOver,
                ),
                child: imageWidget,
              );
            }



            // 7. Bọc InteractiveViewer (Zoom/Pan) bên ngoài cùng
            // Để khi zoom không ảnh hưởng đến khung chụp RepaintBoundary
            Widget interactiveManualLayer = InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: imageWidget,
            );

            // ===========================================================
            // LAYER 2: KẾT HỢP VỚI ẢNH API (STACK)
            // ===========================================================

            return RepaintBoundary(
              key: _repaintBoundaryKey, // Máy ảnh chụp tất cả các lớp này
              child: Stack(
                alignment: Alignment.center,
                children: [

                  // ==================================================
                  // LAYER 1: ẢNH GỐC CHỈNH SỬA (Luôn nằm dưới cùng)
                  // ==================================================
                  interactiveManualLayer, // (Biến này bạn đã định nghĩa ở trên)

                  // ==================================================
                  // LAYER 2: ẢNH TỪ API (Nếu có thì hiện đè lên Layer 1)
                  // ==================================================
                  if (provider.topApiImage != null)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black, // Nền đen để che hoàn toàn Layer 1
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          // Bọc RotatedBox & Transform để ảnh API xoay/lật theo ý muốn
                          child: RotatedBox(
                            quarterTurns: provider.degrees,
                            child: Transform.scale(
                              scaleX: provider.isFlipHorizontal ? -1 : 1,
                              scaleY: provider.isFlipVertical ? -1 : 1,
                              child: Image.memory(
                                provider.topApiImage!,
                                fit: provider.boxFit, // Đồng bộ chế độ Fit
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // ==================================================
                  // LAYER 3: VĂN BẢN (Luôn nằm trên cùng)
                  // ==================================================
                  // Dùng cú pháp spread (...) để rải danh sách chữ ra
                  ...provider.texts.map((textItem) => DraggableTextWidget(textItem: textItem)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}