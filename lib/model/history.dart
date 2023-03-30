import 'package:reminder/model/quiz.dart';

class HistoryFields{
  static final String id = 'id';
  static final String lastDate = 'last_date';
  static final String continued = 'continued';
}

class History{
  static String tableName = 'history';

  final int? id;
  final DateTime lastDate;
  final int continued;

  const History({
    this.id,
    required this.lastDate,
    required this.continued,
  });

  Map<String, dynamic> toJson(){
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
    );
  }

  History clone({int? id}){
    return History(
      id: id,
      lastDate: lastDate,
      continued: continued,
    );
  }
}