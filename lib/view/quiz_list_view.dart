import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reminder/model/category.dart';
import 'package:reminder/repository/QuizRepository.dart';

import '../model/quiz.dart';

class QuizListView extends StatefulWidget {
  final Category category;
  const QuizListView({Key? key, required this.category}) : super(key: key);

  @override
  State<QuizListView> createState() => _QuizListViewState();
}

class _QuizListViewState extends State<QuizListView> {

  void update() => setState(() {});

  void createQuiz(String question, String answer) async {
    Quiz quiz = Quiz(
      categoryId: widget.category.id!,
      question: question,
      answer: answer,
    );

    await QuizRepository.save(quiz);
    update();
  }

  Future<List<Quiz>> _loadQuizList() async {
    return await QuizRepository.findAllByCategoryId(widget.category.id!);
  }

  void updateQuiz(int id, String question, String answer) async {
    await QuizRepository.updateById(id, question, answer);
    update();
  }

  void deleteQuiz(int id) async {
    await QuizRepository.deleteById(id);
    update();
  }

  Widget solveQuiz(Quiz quiz){
    String? inputText;

    AlertDialog alertDialog = AlertDialog(
      alignment: Alignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('문제'),
          Text(quiz.question),
          SizedBox(height: 10),
          Text('정답'),
          TextField(
            onChanged: (value) => inputText = value,
            decoration: InputDecoration(
              hintText: '정답을 입력하세요.',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('취소')),
        TextButton(onPressed: () {
          Navigator.pop(context);
          if (inputText == quiz.answer) {
            showDialog(context: context, builder: (
                BuildContext context) {
              return AlertDialog(
                content: Text('정답입니다'),
              );
            });
          } else {
            showDialog(context: context, builder: (
                BuildContext context) {
              return AlertDialog(
                content: Text('오답입니다'),
              );
            });
          }
        }, child: Text('제출')),
      ],
    );

    return alertDialog;
  }

  Widget _quiz(Quiz quiz) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(quiz.question),
            onTap: () {
              showDialog(context: context, builder: (BuildContext context) {
                return solveQuiz(quiz);
              });
            },
          ),
        ),
        IconButton(onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            String? question;
            String? answer;
            return AlertDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('문제'),
                  TextFormField(
                    onChanged: (value) => question = value,
                    initialValue: quiz.question,
                  ),
                  Text('정답'),
                  TextFormField(
                    onChanged: (value) => answer = value,
                    initialValue: quiz.answer,
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('닫기')),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                  if (question != null && answer != null) {
                    updateQuiz(quiz.id!, question!, answer!);
                  }
                }, child: Text('수정')),
              ],
            );
          });
        }, icon: const Icon(Icons.info_outline)),
        IconButton(
          onPressed: () {
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                content: Text('정말 삭제하시겠습니까?'),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text('취소')),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                    deleteQuiz(quiz.id!);
                  }, child: Text('삭제')),
                ],
              );
            });
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: _loadQuizList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('오류'),
            );
          }
          if (snapshot.hasData) {
            var datas = snapshot.data;
            return ListView(
              children: List.generate(
                  datas!.length, (index) => _quiz(datas[index])),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: FutureBuilder<List<Quiz>>(
        future: _loadQuizList(),
        builder: (context, snapshot){
          return BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    String? question;
                    String? answer;

                    AlertDialog alertDialog = AlertDialog(
                      alignment: Alignment.center,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '문제',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextField(
                            onChanged: (value) => question = value,
                            decoration: InputDecoration(
                              hintText: '문제를 입력하세요.',
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            '정답',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextField(
                            onChanged: (value) => answer = value,
                            decoration: InputDecoration(
                              hintText: '정답을 입력하세요.',
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.only(
                        top: 10,
                        left: 14,
                        right: 14,
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom * 20,
                      ),
                      actions: [
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text('취소')),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                          if (question != null && answer != null) {
                            createQuiz(question!, answer!);
                          }
                        }, child: Text('추가')),
                      ],
                    );

                    showDialog(context: context, builder: (BuildContext context) {
                      return alertDialog;
                    });
                  },
                  child: Text('문제 추가',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if(snapshot.hasError){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          content: Text('문제가 발생했습니다.'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('닫기')),
                          ],
                        );
                      });
                    }
                    if(snapshot.hasData){
                      var datas = snapshot.data;
                      if(datas!.isEmpty){
                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            content: Text('하나 이상의 문제를 추가해주세요.'),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text('닫기')),
                            ],
                          );
                        });
                      }

                      var randomQuiz = datas[Random().nextInt(datas.length)];
                      showDialog(context: context, builder: (BuildContext context){
                        return solveQuiz(randomQuiz);
                      });
                    }
                  },
                  child:
                    Text('랜덤 풀기',
                      style: TextStyle(color: Colors.black),
                    ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
