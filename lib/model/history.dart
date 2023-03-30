import 'package:reminder/model/quiz.dart';

class HistoryFields{
  static final String id = 'id';
  static final String lastDate = 'last_date';
  static final String continued = 'continued';
  static final String baseCategory = 'base_category';
}

class History{
  static String tableName = 'history';

  final int? id;
  final DateTime lastDate;
  final int continued;
  final int? baseCategory;

  const History({
    this.id,
    required this.lastDate,
    required this.continued,
    this.baseCategory,
  });

  Map<String, dynamic> toJson(){
    if(baseCategory != null){
      return{
        HistoryFields.id: id,
        HistoryFields.lastDate: lastDate.toIso8601String(),
        HistoryFields.continued: continued,
        HistoryFields.baseCategory: baseCategory,
      };
    }
    return{
      HistoryFields.id: id,
      HistoryFields.lastDate: lastDate.toIso8601String(),
      HistoryFields.continued: continued,
    };

  }

  factory History.fromJson(Map<String, dynamic> json){
    return History(
      id: json[HistoryFields.id] as int?,
      lastDate: DateTime.parse(json[HistoryFields.lastDate] as String),
      continued: json[HistoryFields.continued] as int,
      baseCategory: json[HistoryFields.baseCategory] as int?,
    );
  }

  History clone({int? id}){
    return History(
      id: id,
      lastDate: lastDate,
      continued: continued,
      baseCategory: baseCategory,
    );
  }
}