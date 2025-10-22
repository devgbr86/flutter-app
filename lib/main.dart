import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'pages/home/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Motoboy',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
