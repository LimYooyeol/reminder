import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reminder/repository/sql_database.dart';
import 'package:reminder/view/home.dart';

const Map<String, String> UNIT_ID = kReleaseMode? {
    'android': 'ca-app-pub-2917734040573161/1953416706',
  }: {
    'android' : 'ca-app-pub-3940256099942544/6300978111',
  };


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
