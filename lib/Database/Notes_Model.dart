// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:notes_app/Database/AppDataBase.dart';

class noteModel {
  int? note_id;
  String title;
  String desc;

  noteModel({this.note_id, required this.title, required this.desc});

  //Note Model From map
  //factory func = model to map
  factory noteModel.fromMap(Map<String, dynamic> map) {
    return noteModel(
      note_id: map[DbHelper.Note_Column_Id],
      title: map[DbHelper.Note_Column_Title],
      desc: map[DbHelper.Note_Column_Desc],
    );
  }

  //map data from note model
  Map<String, dynamic> toMap() {
    return {
      DbHelper.Note_Column_Id: note_id,
      DbHelper.Note_Column_Title: title,
      DbHelper.Note_Column_Desc: desc
    };
  }
}
