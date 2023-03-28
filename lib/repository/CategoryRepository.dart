
import 'package:reminder/repository/sql_database.dart';

import '../model/category.dart';

class CategoryRepository{

  static Future<Category> save(Category category) async{
    var db = await SqlDatabase().database;

    var id =  await db?.insert(Category.tableName, category.toJson());
    return category.clone(id: id);
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
}