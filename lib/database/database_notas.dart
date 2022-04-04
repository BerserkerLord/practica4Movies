import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:practica2/models/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseNotes {
  static final _nombreBD = "PATM2022";
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
        "CREATE TABLE tbl_notas (idNota INTEGER PRIMARY KEY, titulo varchar(25), dscNota varchar(500))");
  }

  //_updTablas(Database db, int oldVersion, int newVersion) {}

  Future<int> insertar(Map<String, dynamic> row) async {
    var dbConexion = await database;
    return dbConexion!.insert("tbl_notas", row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    var dbConexion = await database;
    return dbConexion!.update("tbl_notas", row,
        where: "idNota = ?", whereArgs: [row['idNota']]);
  }

  Future<int> delete(int idNota) async {
    var dbConexion = await database;
    return await dbConexion!
        .delete("tbl_notas", where: "idNota = ?", whereArgs: [idNota]);
  }

  Future<List<NotesDAO>> getAllNotes() async {
    var dbConexion = await database;
    var result = await dbConexion!.query("tbl_notas");
    var list = result.map((note) => NotesDAO.fromMap(note)).toList();
    return list;
  }
}
