import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';

class ToolItems extends StatefulWidget {
  const ToolItems({super.key});

  @override
  State<ToolItems> createState() => _ToolItemsState();
}

class _ToolItemsState extends State<ToolItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        spacing: 30,
        children: [
          InkWell(
              onTap: (){
                context.read<ImageState>().openCropTool(context);
              },
              child: Image.asset('assets/icons/cut.png',color: Colors.white,)),
          InkWell(
              onTap: (){
                _showAddTextDialog(context);
              },
              child: Image.asset('assets/icons/text.png',color: Colors.white,)),
          InkWell(

              onTap: (){
                context.read<ImageState>().rotateLeft();
              },
              child: Image.asset('assets/icons/turnleft.png',color: Colors.white,)),
          InkWell(
              onTap: (){
                context.read<ImageState>().rotateRight();
              },
              child: Image.asset('assets/icons/turnright.png',color: Colors.white,)),
          InkWell(
              onTap: (){
                context.read<ImageState>().flipHorizontal();
              },
              child: Image.asset('assets/icons/horizontal.png',color: Colors.white,)),
          InkWell(
              onTap: (){
                context.read<ImageState>().flipVertical();

              },
              child: Image.asset('assets/icons/vertical.png',color: Colors.white,)),
          InkWell(

              onTap: (){
                context.read<ImageState>().fullScreen();
              },
              child: Image.asset('assets/icons/fullscreen.png',color: Colors.white,)),
          InkWell(

              onTap: () {
                context.read<ImageState>().cleanImage();
              },
              child: Image.asset('assets/icons/delete.png',color: Colors.white,)),

          InkWell(
              onTap: (){
                context.read<ImageState>().removeTopLayer();
              },
              child: Image.asset('assets/icons/back.png',color: Colors.white,)),
        ],
      ),
    );
  }
}


// Hàm hiện hộp thoại nhập
// Trong file chứa hàm _showAddTextDialog

void _showAddTextDialog(BuildContext context) {
  final TextEditingController _controller = TextEditingController();
  Color _selectedColor = Colors.red; // Màu mặc định ban đầu

  // Danh sách 12 màu
  final List<Color> palette = [
    Colors.red, Colors.green, Colors.blue, Colors.white, Colors.yellow, Colors.tealAccent,
    Colors.purple, Colors.orange, Colors.pink, Colors.cyan, Colors.lime, Colors.indigo,
  ];

  showDialog(
    context: context,
    builder: (context) {
      // Dùng StatefulBuilder để cập nhật giao diện bên trong Dialog
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Nhập văn bản"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: "Nhập nội dung..."),
                  autofocus: true,
                ),
                const SizedBox(height: 20),

                // === GRIDVIEW MÀU SẮC ===
                SizedBox(
                  height: 100,
                  width: 200,
                  child: GridView.builder(
                    itemCount: palette.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final color = palette[index];

                      // Kiểm tra xem ô này có đang được chọn không
                      final bool isSelected = (_selectedColor == color);

                      return GestureDetector(
                        onTap: () {
                          // Cập nhật trạng thái
                          setStateDialog(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,

                            // --- PHẦN QUAN TRỌNG: VIỀN (BORDER) ---
                            border: isSelected
                                ? Border.all(
                              color: Colors.black38, // Màu viền khi chọn
                              width: 5.0,               // Độ dày viền khi chọn
                            )
                                : Border.all(
                              color: Colors.grey.shade300, // Màu viền mờ khi chưa chọn
                              width: 1.0,
                            ),
                            // ---------------------------------------

                            // Thêm bóng đổ nhẹ cho đẹp (tùy chọn)
                            boxShadow: isSelected ? [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                            ] : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    context.read<ImageState>().addNewText(_controller.text, _selectedColor);
                    Navigator.pop(context);
                  }
                },
                child: const Text("Thêm"),
              ),
            ],
          );
        },
      );
    },
  );
}
