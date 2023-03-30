
import 'package:reminder/repository/sql_database.dart';

import '../model/history.dart';

class HistoryRepository{

  //저장
  static Future<History> save(History history) async{
    var db = await SqlDatabase().database;

    var id = await db?.insert(History.tableName, history.toJson());

    return history.clone(id:id);
  }

  // 조회
  static Future<History?> getHistory() async{
    var db = await SqlDatabase().database;

    var result = await db?.query(History.tableName, columns: [
     HistoryFields.lastDate,
     HistoryFields.continued,
    ]);

    var listResult = result!.map((data){
      return History.fromJson(data);
    }).toList();

    if(listResult.isEmpty){
      return null;
    }

    return listResult[0];
  }

  // 수정
  static Future<void> update(DateTime lastDate, int continued) async{
    var db = await SqlDatabase().database;

    await db?.update(History.tableName,
      {
        HistoryFields.lastDate: lastDate.toIso8601String(),
        HistoryFields.continued: continued,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

}