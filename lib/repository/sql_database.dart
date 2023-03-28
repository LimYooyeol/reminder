import 'package:path/path.dart';
import 'package:reminder/model/category.dart';
import 'package:sqflite/sqflite.dart';

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
  }

  void _databaseCreate(Database db, int version) async{
    await db.execute('''
      create table ${Category.tableName}(
        ${CategoryFields.id}    integer   primary key autoincrement, 
        ${CategoryFields.name}  text      not null
      )
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