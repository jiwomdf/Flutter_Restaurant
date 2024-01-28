import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'entity/restaurant_entity.dart';

class DbService {
  static late Database _database;
  static const String _dbName = 'note_db.db';
  static const String _tableRestaurant = 'restaurant';

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, _dbName),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableRestaurant (
             id INTEGER PRIMARY KEY,
             title TEXT, description TEXT
           )''',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertRestaurant(RestaurantEntity restaurantEntity) async {
    final db = await database;
    await db.insert(_tableRestaurant, restaurantEntity.toJson());
  }

  Future<List<RestaurantEntity>> getRestaurant() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableRestaurant);
    return results.map((res) => RestaurantEntity.fromJson(res)).toList();
  }

  Future<dynamic> getRestaurantById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tableRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeRestaurant(String id) async {
    final db = await database;
    await db.delete(
      _tableRestaurant,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}