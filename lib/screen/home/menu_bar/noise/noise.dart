import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/menu_bar/noise/gaussian_filter/kernel3_3.dart';
import 'package:project_xla/screen/home/menu_bar/noise/gaussian_filter/kernel5_5.dart';
import 'package:project_xla/screen/home/menu_bar/noise/gaussian_filter/kernel7_7.dart';
import 'package:project_xla/screen/home/menu_bar/noise/gaussion.dart';
import 'package:project_xla/screen/home/menu_bar/noise/mean_filter/kernel3_3.dart';
import 'package:project_xla/screen/home/menu_bar/noise/mean_filter/kernel5_5.dart';
import 'package:project_xla/screen/home/menu_bar/noise/mean_filter/kernel7_7.dart';
import 'package:project_xla/screen/home/menu_bar/noise/median_filter/kernel3_3.dart';
import 'package:project_xla/screen/home/menu_bar/noise/median_filter/kernel5_5.dart';
import 'package:project_xla/screen/home/menu_bar/noise/median_filter/kernel7_7.dart';
import 'package:project_xla/screen/home/menu_bar/noise/salt_pepper.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';

import '../../../provider/api/APIProvider.dart';

class Noise extends StatelessWidget {
  const Noise({super.key});

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey.withValues(alpha: 0.2);
            }
            return Colors.transparent;
          }
          ),
        ),
        menuChildren: [
          SaltPepper(onPressedsaltPepper: () async {
            final imageState = context.read<ImageState>();
            final apiProvider = context.read<APIProvider>();

            if (imageState.imageFile == null) return;

            final result = await apiProvider.applySPNoise(imageState.imageFile!);
            if (result != null) imageState.updateImageFromApi(result);
          },),

          Gaussion(onPressedGaussion: () async {
            final imageState = context.read<ImageState>();
            final apiProvider = context.read<APIProvider>();

            if (imageState.imageFile == null) return;

            final result = await apiProvider.applyGaussianNoise(imageState.imageFile!);
            if (result != null) imageState.updateImageFromApi(result);
          },
          ),
          SubmenuButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey.shade700;
                  }
                  return Colors.black;
                }),
              ),
              menuChildren: [
                KernelThree(onPressedMeanThree: () => _applyMeanFilter(context, 3)),
                KernelFive(onPressedMeanFive: () => _applyMeanFilter(context, 5),),
                KernelSeven(onPressedMeanSeven: () => _applyMeanFilter(context, 7),)
              ], 
              child: Text('Denoise using mean filter',style: TextStyle(color: Colors.white54,),)),

          SubmenuButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey.shade700;
                  }
                  return Colors.black;
                }),
              ),
              menuChildren: [
                KernelThreeMedian(onPressedMedianThree: () => _applyMedianFilter(context, 3),),
                KernelFiveMedian(onPressedMedianFive: () => _applyMedianFilter(context, 5),),
                KernelSevenMedian(onPressedMedianSeven: () => _applyMedianFilter(context, 7),)
              ],
              child: Text('Denoise using median filter',style: TextStyle(color: Colors.white54,),)),

          SubmenuButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.grey.shade700;
                  }
                  return Colors.black;
                }),
              ),
              menuChildren: [
                KernelThreeGaussian(onPressedGaussianThree: () => _applyGaussianFilter(context, 3),),
                KernelFiveGaussian(onPressedMedianFive: () => _applyGaussianFilter(context, 5),),
                KernelGassianSeven(onPressedGaussionSeven: () => _applyGaussianFilter(context, 7),)
              ],
              child: Text('Denoise using Gaussian filter',style: TextStyle(color: Colors.white54,),))


        ],
        child: Text('Noise',style: TextStyle(color: Colors.white,),));
  }
}

    // Hàm xử lý logic
    void _applyMeanFilter(BuildContext context, int size) async {
      // 1. Lấy 2 ông thần Provider ra
      final imageState = context.read<ImageState>();
      final apiProvider = context.read<APIProvider>();

      // 2. Kiểm tra có ảnh chưa
      if (imageState.imageFile == null) {
        print("Chưa chọn ảnh!");
        return;
      }

      print("Đang gọi Server lọc Mean $size x $size...");

      // 3. Gọi API (Hàm ở Bước 2)
      final result = await apiProvider.applyFilter(
          imageState.imageFile!,
          'mean', // Gửi type là 'mean'
          size
      );

      // 4. CẬP NHẬT UI (Đây là bước quan trọng nhất)
      if (result != null) {
        // Dòng này sẽ bắn tín hiệu sang file RangeImage.dart để vẽ lại ảnh mới
        imageState.updateImageFromApi(result);
        print("Đã cập nhật ảnh mới!");
      }
    }

// Hàm Lọc Trung Vị (Median Filter)
void _applyMedianFilter(BuildContext context, int size) async {
  final imageState = context.read<ImageState>();
  final apiProvider = context.read<APIProvider>();

  // Kiểm tra
  if (imageState.imageFile == null) {
    print("Chưa chọn ảnh!");
    return;
  }
  print("Đang gọi Server lọc Median $size x $size...");

  // Gọi API
  // Lưu ý: Tôi truyền thêm 'imageState.topApiImage' để hỗ trợ "Chồng hiệu ứng"
  // (Nếu APIProvider của bạn đã cập nhật như bài trước)
  final result = await apiProvider.applyFilter(
      imageState.imageFile!,
      'median', // Gửi type là 'median'
      size
  );
  // Cập nhật UI
  if (result != null) {
    imageState.updateImageFromApi(result);
    print("Đã cập nhật ảnh Median mới!");
  }
}

void _applyGaussianFilter(BuildContext context, int size) async {
  // 1. Lấy 2 ông thần Provider ra
  final imageState = context.read<ImageState>();
  final apiProvider = context.read<APIProvider>();

  // 2. Kiểm tra có ảnh chưa
  if (imageState.imageFile == null) {
    print("Chưa chọn ảnh!");
    return;
  }

  print("Đang gọi Server lọc Gaussian $size x $size...");

  // 3. Gọi API (Hàm ở Bước 2)
  final result = await apiProvider.applyFilter(
      imageState.imageFile!,
      'gaussian', // Gửi type là 'mean'
      size
  );

  // 4. CẬP NHẬT UI (Đây là bước quan trọng nhất)
  if (result != null) {
    // Dòng này sẽ bắn tín hiệu sang file RangeImage.dart để vẽ lại ảnh mới
    imageState.updateImageFromApi(result);
    print("Đã cập nhật ảnh mới!");
  }
}