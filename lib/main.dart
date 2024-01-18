import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/domain/data/api/api_service.dart';

import 'features/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(useMaterial3: true, colorScheme: const ColorScheme.dark()),
      home: MainScreen(
          title: 'Restaurant App',
          apiService: ApiService(),
      ),
    );
  }
}