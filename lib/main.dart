import 'package:flutter/material.dart';
import 'package:reminder/repository/sql_database.dart';
import 'package:reminder/view/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
