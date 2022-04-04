import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../network/api_popular.dart';

import '../models/popular_model.dart';

class DatabaseMovies{
  static final _nombreBD = "Movies";
  static final _versionBD = 1;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path, _nombreBD);
    return await openDatabase(
      rutaBD,
      version: _versionBD,
      onCreate: _crearTablas,
    );
  }

  _crearTablas(Database db, int version) {
    db.execute(
        "CREATE TABLE tbl_favourite (id INTEGER PRIMARY KEY)");
  }

  Future<int> insertar(Map<String, dynamic> row) async {
    var dbConexion = await database;
    Map<String, int> id = {'id': row['id']};
    return dbConexion!.insert("tbl_favourite", id);
  }

  Future<int> delete(int idMovie) async {
    var dbConexion = await database;
    return await dbConexion!
        .delete("tbl_favourite", where: "id = ?", whereArgs: [idMovie]);
  }

  Future<bool> exists(Map<String, dynamic> row) async{
    var dbConexion = await database;
    var res = await dbConexion!.rawQuery('SELECT * FROM tbl_favourite WHERE id=?', [row['id']]);
    return res.isEmpty ? false : true;
  }

  Future<List<PopularModel>?> getAllFavorites() async {
    ApiPopular? apiPopular = ApiPopular();
    var dbConexion = await database;
    var result = await dbConexion!.query("tbl_favourite");
    var list = result.toList();
    return apiPopular.getAllFavourites(list);
  }
}