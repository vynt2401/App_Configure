import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../../../text_overlap_model/text_overlap_model.dart';
import '../../crop_screen/crop_screen.dart';

class ImageState with ChangeNotifier {
  File? _imageFile;
  img.Image? decodedImage;
  img.Image? originalImage;

  // Biến trạng thái
  bool _isFlipHorizontal = false;
  bool _isFlipVertical = false;
  int _degrees = 0;

  // Adjustment
  double _blur = 0.0;
  double _brightness = 0.0;
  double _contrast = 1.0;
  Color _overlayColor = Colors.transparent;
  double _zoom = 1.0;
  BoxFit _boxFit = BoxFit.contain;

  // API Layers
  final List<Uint8List> _apiLayers = [];

  //text overlap
  final List<TextOverlay> _texts = [];


  // Getters
  File? get imageFile => _imageFile;
  bool get isFlipHorizontal => _isFlipHorizontal;
  bool get isFlipVertical => _isFlipVertical;
  int get degrees => _degrees;
  double get blur => _blur;
  double get brightness => _brightness;
  double get contrast => _contrast;
  Color get overlayColor => _overlayColor;
  double get zoom => _zoom;
  BoxFit get boxFit => _boxFit;

  // Lấy ảnh trên đỉnh stack (nếu có)
  Uint8List? get topApiImage => _apiLayers.isEmpty ? null : _apiLayers.last;
  bool get hasApiLayers => _apiLayers.isNotEmpty; // Helper kiểm tra có layer ko
  List<TextOverlay> get texts => _texts;

  // --- CẦU NỐI ĐỂ GỌI HÀM SAVE CỦA UI ---
  VoidCallback? _onSaveUI; // Biến chứa hàm save của UI

  // Hàm để UI đăng ký
  void registerSaveCallback(VoidCallback callback) {
    _onSaveUI = callback;
  }
  // ---------------------------------------

  // Setters
  void setBlur(double value) { _blur = value; notifyListeners(); }
  void setBrightness(double value) { _brightness = value; notifyListeners(); }
  void setContrast(double value) { _contrast = value; notifyListeners(); }
  void setOverlayColor(Color color) { _overlayColor = color; notifyListeners(); }
  void setZoom(double value) { _zoom = value.clamp(0.5, 5.0); notifyListeners(); }

  // Reset & Transform
  void clearAdjustments() {
    _blur = 0.0; _brightness = 0.0; _contrast = 1.0; _overlayColor = Colors.transparent;
    notifyListeners();
  }
  void clearState() {
    _isFlipHorizontal = false;
    _isFlipVertical = false;
    _degrees = 0; }
  void flipHorizontal() {
    _isFlipHorizontal = !_isFlipHorizontal;
    notifyListeners(); }
  void flipVertical() {
    _isFlipVertical = !_isFlipVertical;
    notifyListeners(); }
  void rotateRight() {
    _degrees = (_degrees + 1) % 4;
    notifyListeners(); }
  void rotateLeft() {
    _degrees = (_degrees - 1);
    if (_degrees < 0) _degrees = 3;
    notifyListeners(); }

  void fullScreen() {
    if (_boxFit == BoxFit.contain) _boxFit = BoxFit.fill;
    else _boxFit = BoxFit.contain;
    notifyListeners();
  }

  void cleanImage() {
    _imageFile = null; decodedImage = null; originalImage = null;
    _apiLayers.clear(); // Xóa luôn list API
    clearAdjustments();
    clearState();
    _texts.clear();
    notifyListeners();
  }

  // API Image Handling
  void updateImageFromApi(Uint8List imageBytes) {
    _apiLayers.add(imageBytes);
    notifyListeners();
  }

  void removeTopLayer() {
    if (_apiLayers.isNotEmpty) {
      _apiLayers.removeLast();
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _imageFile = File(result.files.single.path!);
      final bytes = await _imageFile!.readAsBytes();


      originalImage = img.decodeImage(bytes);
      if (originalImage != null) decodedImage = img.decodeImage(bytes);
      _apiLayers.clear(); // Reset API layers khi chọn ảnh mới
      clearAdjustments();
      clearState();
      notifyListeners();
    }
  }


  // === HÀM SAVE MỚI (GỌI UI) ===
  // Khi bạn bấm nút Save ở Menu, hãy gọi hàm này
  void triggerSave() {
    if (_onSaveUI != null) {
      print("Provider: Đang gọi hàm Save của UI...");
      _onSaveUI!(); // Kích hoạt hàm saveImageSmart bên UI
    } else {
      print("Lỗi: UI chưa đăng ký hàm Save!");
    }
  }

// Trong file image_state.dart

  // Trong file image_state.dart

  Future<void> openCropTool(BuildContext context) async {
    if (_imageFile == null) return;

    // 1. Lấy dữ liệu ảnh đang hiển thị để cắt
    // Nếu đang có ảnh API (Gray, Noise...) thì cắt ảnh đó.
    // Nếu không thì cắt ảnh gốc.
    final Uint8List bytesToCrop = topApiImage ?? await _imageFile!.readAsBytes();

    // 2. Mở màn hình cắt
    final Uint8List? croppedBytes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropScreen(imageBytes: bytesToCrop),
      ),
    );

    // 3. Xử lý kết quả
    if (croppedBytes != null) {
      // Thay vì ghi đè file gốc, ta đẩy nó vào danh sách API Layers
      updateImageFromApi(croppedBytes);

      print(" Đã cắt ảnh ");
    }
  }


  /////////////////////////////#################////////////////////////
  // Hàm thêm chữ mới
  void addNewText(String content, Color color) {
    _texts.add(TextOverlay(
      id: DateTime.now().toString(), // ID duy nhất
      text: content,
      color: color,
    ));
    notifyListeners();
  }

  // Hàm cập nhật vị trí chữ (khi kéo thả)
  void updateTextPosition(String id, Offset newPosition) {
    final index = _texts.indexWhere((element) => element.id == id);
    if (index != -1) {
      _texts[index].position = newPosition;
      notifyListeners();
    }
  }

  // Hàm xóa chữ (nếu cần)
  void removeText(String id) {
    _texts.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}