import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

import 'cart_model.dart';

class DbHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    io.Directory documentsDirectory =
    await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "cart.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE cart ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "prdouctid TEXT UNIQUE, "
          "productName TEXT, "
          "initalPrice INTEGER, "
          "productPrice INTEGER, "
          "productQuantity INTEGER, "
          "productImage TEXT, "
          "unitTag TEXT"
          ")",
    );
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert(
      "cart",
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return cart;
  }
  Future<List<Cart>> getCart() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query("cart");
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      "cart",
      where: "id = ?",
      whereArgs: [id],
    );
  }
  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;
    return await dbClient!.update(
      "cart",
      cart.toMap(),
      where: "id = ?",
      whereArgs: [cart.id],
    );
  }

}