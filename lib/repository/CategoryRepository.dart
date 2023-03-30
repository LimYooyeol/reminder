
import 'package:reminder/repository/sql_database.dart';

import '../model/category.dart';

class CategoryRepository{

  // 저장
  static Future<Category> save(Category category) async{
    var db = await SqlDatabase().database;

    var id =  await db?.insert(Category.tableName, category.toJson());
    return category.clone(id: id);
  }

  // 삭제
  static Future<void> deleteById(int? id) async{
    var db = await SqlDatabase().database;

    db?.delete(Category.tableName,
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Category>> getList() async{
    var db = await SqlDatabase().database;

    var result = await db?.query(Category.tableName, columns: [
      CategoryFields.id,
      CategoryFields.name
    ]);

    return result!.map((data){
      return Category.fromJson(data);
    }).toList();

  }

  static Future<void> updateById(int id, String name) async{
    var db = await SqlDatabase().database;
    
    await db?.update(Category.tableName,
      {CategoryFields.name : name},
      where: '${CategoryFields.id} = ?',
      whereArgs: [id],
    );
  }
}