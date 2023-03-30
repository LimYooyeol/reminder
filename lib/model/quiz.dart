
class QuizFields{
  static final String id = 'id';
  static final String categoryId = 'category_id';
  static final String question = 'question';
  static final String answer = 'answer';
}

class Quiz{
  static String tableName = 'quiz';

  final int? id;
  final int? categoryId;
  final String question;
  final String answer;

  const Quiz({
    this.id,
    required this.categoryId,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson(){
    return{
      QuizFields.id: id,
      QuizFields.categoryId : categoryId,
      QuizFields.question: question,
      QuizFields.answer: answer,
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json){
    return Quiz(
      id: json[QuizFields.id] as int?,
      categoryId: json[QuizFields.categoryId] as int,
      question: json[QuizFields.question] == null? '' : json[QuizFields.question] as String,
      answer: json[QuizFields.answer] == null? '': json[QuizFields.answer] as String,
    );
  }

  Quiz clone({int? id}){
    return Quiz(
        id: id,
        categoryId: categoryId,
        question: question,
        answer: answer
    );
  }
}