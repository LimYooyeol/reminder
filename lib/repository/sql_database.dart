import 'package:path/path.dart';
import 'package:reminder/model/category.dart';
import 'package:sqflite/sqflite.dart';

import '../model/history.dart';
import '../model/quiz.dart';

class SqlDatabase{
  static final SqlDatabase instance = SqlDatabase._instance();

  Database? _database;

  SqlDatabase._instance(){
    _initDataBase();
  }

  factory SqlDatabase(){
    return instance;
  }


  Future<void> _initDataBase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'reminder.db');

    _database = await openDatabase(path, version: 1, onCreate: _databaseCreate);
    if(_database != null){
      await _database!.execute("PRAGMA foreign_keys = ON");
    }
  }

  void _databaseCreate(Database db, int version) async{
    await db.execute('''
      create table ${Category.tableName}(
        ${CategoryFields.id}    integer   primary key autoincrement, 
        ${CategoryFields.name}  text      not null
      );
    ''');

    await db.execute(''' 
      create table ${Quiz.tableName}(
        ${QuizFields.id}          integer   primary key autoincrement,
        ${QuizFields.categoryId}  integer,
        ${QuizFields.question}    text    not null,
        ${QuizFields.answer}      text    not null,
        FOREIGN KEY (${QuizFields.categoryId}) REFERENCES ${Category.tableName}(id) ON DELETE CASCADE
      ); 
    ''');

    await db.execute(''' 
      create table ${History.tableName}(
        ${HistoryFields.id}           integer primary key autoincrement,
        ${HistoryFields.lastDate}     text    not null,
        ${HistoryFields.continued}    integer not null,
        ${HistoryFields.baseCategory} integer,
        FOREIGN KEY (${HistoryFields.baseCategory}) REFERENCES ${Category.tableName}(id) on delete set null
      );
    ''');
  }

  void closeDataBase() async{
    final _database = this._database;
    if(_database != null) await _database.close();
  }

  Future<Database?> get database async{
    if(_database != null) {
      return _database;
    }
    await _initDataBase();
    return _database;
  }

}