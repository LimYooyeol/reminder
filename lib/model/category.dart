import 'dart:convert';

class CategoryFields{
  static final String id = 'id';
  static final String name = 'name';
}

class Category{
  static String tableName = 'category';

  final int? id;
  final String name;

  const Category({
    this.id,
    required this.name
  });

  Map<String, dynamic> toJson() {
    return {
      CategoryFields.id: id,
      CategoryFields.name: name
    };
  }

  Category clone({int? id}) {
    return Category(
      id: id ?? this.id,
      name: name
    );
  }

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json[CategoryFields.id] as int?,
      name: json[CategoryFields.name] == null ? '' : json[CategoryFields.name] as String,
    );
  }
}