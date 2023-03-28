import 'package:flutter/material.dart';

class QuizListView extends StatefulWidget {
  final int? categoryId;
  const QuizListView({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<QuizListView> createState() => _QuizListViewState();
}

class _QuizListViewState extends State<QuizListView> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.categoryId.toString());
  }
}
