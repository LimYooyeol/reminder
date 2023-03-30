import 'package:reminder/model/quiz.dart';
import 'package:reminder/repository/sql_database.dart';

class QuizRepository{

  // 저장
  static Future<Quiz> save(Quiz quiz) async{
    var db = await SqlDatabase().database;

    var id = await db?.insert(
      Quiz.tableName,
      quiz.toJson()
    );
    return quiz.clone(id: id);
  }

  // 리스트
  static Future<List<Quiz>> findAllByCategoryId(int categoryId) async{
    var db = await SqlDatabase().database;

    var result = await db!.query(Quiz.tableName,
      columns: [
        QuizFields.id,
        QuizFields.categoryId,
        QuizFields.question,
        QuizFields.answer
      ],
      where: '${QuizFields.categoryId} = ?',
      whereArgs: [categoryId],
    );

    return result.map((data){
      return Quiz.fromJson(data);
    }).toList();
  }

  //수정
  static Future<void> updateById(int id, String question, String answer) async{
    var db = await SqlDatabase().database;

    await db?.update(Quiz.tableName,
      {
        QuizFields.question : question,
        QuizFields.answer : answer,
      },
      where: '${QuizFields.id} = ?',
      whereArgs : [id],
    );
  }

  //삭제
  static Future<void> deleteById(int id) async{
    var db = await SqlDatabase().database;

    db?.delete(Quiz.tableName,
      where: '${QuizFields.id} = ?',
      whereArgs: [id],
    );
  }
}