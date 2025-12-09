import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

class APIProvider with ChangeNotifier {
  bool _isProcessing = false;
  String? _errorMessage;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  // Hàm gọi RGB to Gray
  Future<Uint8List?> convertToGrayscale(File imageFile) async {
    return _callApi(imageFile, 'convert-grayscale');
  }

  // Hàm gọi RGB to Binary
  Future<Uint8List?> convertToBinary(File imageFile) async {
    return _callApi(imageFile, 'convert-binary');
  }

  // Gọi API Nhiễu Gaussian (ĐÃ ĐÚNG: mode là gaussian)
  Future<Uint8List?> applyGaussianNoise(File imageFile) async {
    return _callApi(imageFile, 'noise-skimage', fields: {'mode': 'gaussian'});
  }

  // Gọi API Nhiễu Muối Tiêu (ĐÃ ĐÚNG: mode là s&p)
  Future<Uint8List?> applySPNoise(File imageFile) async {
    return _callApi(imageFile, 'noise-skimage', fields: {'mode': 's&p'});
  }

  Future<Uint8List?> applyFilter(File imageFile, String type, int size) async {
    return _callApi(
        imageFile,
        'filter-noise', // Endpoint server
        fields: {
          'type': type,           // 'mean', 'median', 'gaussian'
          'size': size.toString() // '3', '5', '7'
        }
    );
  }

  // Hàm gọi Dò biên Sobel (Wrapper)
  Future<Uint8List?> applySobel(File imageFile) async {
    return _callApi(
        imageFile,       // Tham số 1: File ảnh
        'edge-sobel',    // Tham số 2: Tên endpoint
        fields: {'ksize': '3'} // Tham số 3 (Tùy chọn): Gửi kèm ksize
    );
  }
  //Hàm gọi Dò biên Prewitt
  Future<Uint8List?> applyPrewitt(File imageFile) async {
    return _callApi(
      imageFile,
      'edge-prewitt', // Endpoint mới
      // Prewitt thường cố định kernel 3x3 nên không cần tham số fields
    );
  }

  // Hàm gọi Dò biên Roberts
  Future<Uint8List?> applyRoberts(File imageFile) async {
    return _callApi(
      imageFile,
      'edge-roberts', // Endpoint mới
      // Prewitt thường cố định kernel 3x3 nên không cần tham số fields
    );
  }

  Future<Uint8List?> applyCanny(File imageFile, {int t1 = 100, int t2 = 200}) async {
    return _callApi(
        imageFile,
        'edge-canny', // Endpoint
        fields: {
          't1': t1.toString(),
          't2': t2.toString(),
        }
    );
  }

  Future<Uint8List?> removeBackground(File imageFile) async {
    return _callApi(
        imageFile,
        'remove-bg', // Endpoint
      // Không cần tham số fields nào khác
    );
  }

  Future<Uint8List?> removeForeground(File imageFile) async {
    return _callApi(
      imageFile,
      'remove-foreground', // Endpoint
      // Không cần tham số fields nào khác
    );
  }

  // (Hàm phụ trợ để gọi HTTP)
  Future<Uint8List?> _callApi(File imageFile, String endpoint, {Map<String, String>? fields}) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Nhớ đổi IP 127.0.0.1 thành 10.0.2.2 nếu chạy Emulator
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://127.0.0.1:8000/$endpoint')
      );

      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      // Nếu không có đoạn này, Server sẽ không biết bạn chọn mode nào
      if (fields != null) {
        request.fields.addAll(fields);
      }
      // -------------------------------------

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        _isProcessing = false;
        notifyListeners();
        return response.bodyBytes;
      } else {
        _errorMessage = "Lỗi Server: ${response.statusCode}";
      }
    } catch (e) {
      _errorMessage = "Lỗi: $e";
    }

    _isProcessing = false;
    notifyListeners();
    return null;
  }
}