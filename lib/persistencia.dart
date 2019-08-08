import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calculadora_corredor/calculadora.dart';

class Persistencia {
  static const TABLE = "calculadora";
  static const COL_DISTANCIA = "distancia";
  static const COL_PACE = "pace";
  static const COL_TEMPO = "tempo";

  Map<String, dynamic> toMap(Calculadora calculadora) {
    return {
      COL_DISTANCIA: calculadora.calculaDistancia(),
      COL_PACE: calculadora.calculaPace(),
      COL_TEMPO: calculadora.calculaTempo()
    };
  }

  Future<Database> open() async {
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'calculadora_database.db'),
      // When the database is first created, create a table
      onCreate: (db, version) {
        return db.execute(
          "CREATE table $TABLE ($COL_DISTANCIA TEXT, $COL_PACE TEXT, $COL_TEMPO text)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // Get a reference to the database.
    return database;
  }

  Future<void> insert(Calculadora calculadora) async {
    Database db = await open();
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.

    await db.insert(
      '$TABLE',
      toMap(calculadora),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    Database db = await open();
    return await db.query('$TABLE');
  }

  Future<void> deleteAll() async {
    Database db = await open();
    db.delete(TABLE);
  }
}
