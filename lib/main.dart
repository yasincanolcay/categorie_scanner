import 'dart:io';
import 'package:categorie_scanner/screens/homeScreen/home_screen.dart';
import 'package:categorie_scanner/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(900, 550));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: themeBackColorLight,
        bannerTheme: const MaterialBannerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      color: Colors.brown,
      title: 'Dosya Kategorize Sistemi',
      home: const HomePage(),
    );
  }
}

