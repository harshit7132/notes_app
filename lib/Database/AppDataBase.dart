// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:notes_app/Database/Notes_Model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  //private constructor
  DbHelper._();
  static final DbHelper db = DbHelper._();

  Database? _database;
  static const Note_Table = 'note_Table';
  static const Note_Column_Id = 'note_Id';
  static const Note_Column_Title = 'note_Title';
  static const Note_Column_Desc = 'note_Desc';

  Future<Database> getDb() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDb();
    }
  }

  Future<Database> initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //create path and join to open database
    var dbPath = join(documentsDirectory.path, "noteDB.db");
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        //creating database
        db.execute(
            "Create table $Note_Table ( $Note_Column_Id integer primary key autoincrement, $Note_Column_Title text, $Note_Column_Desc text )");
      },
    );
  }

  Future<bool> addNotes(noteModel note) async {
    var db = await getDb();

    int rowsEffects = await db.insert(Note_Table, note.toMap());

    return rowsEffects > 0 ;
  }

  Future<List<noteModel>> fetchAllNotes() async {
    var db = await getDb();
    List<Map<String, dynamic>> notes = await db.query(Note_Table);
    List<noteModel> Listnotes = [];

    for (Map<String, dynamic> note in notes) {
      noteModel model = noteModel.fromMap(note);
      Listnotes.add(model);
    }

    return Listnotes;
  }

  Future<bool> updateNotes(noteModel note) async {
    var db = await getDb();
    var count = await db.update(Note_Table, note.toMap(),
        where: "$Note_Column_Id = ${note.note_id}");
    return count > 0;
  }

  Future<bool> deleteNotes(int id) async {
    var db = await getDb();
    var count1  = await db.delete(Note_Table,
        where: "$Note_Column_Id = ?", whereArgs: [id.toString()]);
    return count1 > 0 ;
  }
}
