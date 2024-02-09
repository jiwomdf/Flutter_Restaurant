// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental_beginner_restourant/domain/data/api/api_service.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';
import 'package:fundamental_beginner_restourant/features/main/main_screen.dart';
import 'package:fundamental_beginner_restourant/features/main/restaurant_provider.dart';
import 'package:fundamental_beginner_restourant/main.dart';
import 'package:provider/provider.dart';

void main() {

  Widget createHomeScreen() =>
      ChangeNotifierProvider<RestaurantProvider>(
        create: (context) => RestaurantProvider(apiService: ApiService()),
        child: MaterialApp(
            home: MainScreen(
              title: 'Restaurant App',
              apiService: ApiService(),
              dbService: DbService(),
            )
        ),
      );

  testWidgets('expect favorite and setting icon displayed, verify return true', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(IconButton), findsAtLeast(2));
    expect(find.byIcon(Icons.star_rate_sharp), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('expect AppBar displayed, verify return true', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('expect CircularProgressIndicator displayed, verify return true', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

}
