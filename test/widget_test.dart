// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundamental_beginner_restourant/domain/data/api/api_service.dart';
import 'package:fundamental_beginner_restourant/domain/data/api/response/restaurant_element.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';
import 'package:fundamental_beginner_restourant/features/main/main_screen.dart';
import 'package:fundamental_beginner_restourant/features/main/restaurant_provider.dart';
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

  late Map<String,dynamic> json;

  setUp(() {
    json = {
      "id": "id",
      "name": "name",
      "description": "description",
      "pictureId": "pictureId",
      "city": "city",
      "rating": 0.1.toDouble(),
      "menus": null,
    };
  });

  testWidgets('expect favorite and setting icon displayed, verified return true', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(IconButton), findsAtLeast(2));
    expect(find.byIcon(Icons.star_rate_sharp), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('expect AppBar displayed, verified return true', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('expect CircularProgressIndicator displayed, verified return true', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('Restaurant object has correct properties, verified return true', () {
    final userData = Restaurant.fromJson(json);
    expect(userData.id, "id");
    expect(userData.name, "name");
    expect(userData.description, "description");
    expect(userData.pictureId, "pictureId");
    expect(userData.city, "city");
    expect(userData.rating, 0.1.toDouble());
    expect(userData.menus, null);
  });

}
