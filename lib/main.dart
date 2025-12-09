import 'package:flutter/material.dart';
import 'package:project_xla/screen/home/home_screen.dart';
import 'package:project_xla/screen/provider/api/APIProvider.dart';

import 'package:project_xla/screen/provider/upload_images/image_state.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  //window_manager
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1000, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ImageState()),
      ChangeNotifierProvider(create: (_) => APIProvider()), // <-- Thêm cái này
    ],
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
          create: (context) => ImageState(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                sliderTheme: const SliderThemeData(
                  trackHeight: 3, // thu nhỏ thanh
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6), // nút nhỏ
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white24,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white10, // màu hiệu ứng khi kéo
                ),
                scaffoldBackgroundColor: Color(0xFF222222),
                appBarTheme: AppBarThemeData(backgroundColor: Color(0xFF222222))
            ),
            home: HomeScreen(),
          ),
        );
  }
}
