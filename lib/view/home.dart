import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reminder/model/category.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:reminder/model/history.dart';
import 'package:reminder/repository/CategoryRepository.dart';
import 'package:reminder/repository/HistoryRepository.dart';
import 'package:reminder/repository/QuizRepository.dart';
import 'package:reminder/view/quiz_list_view.dart';

import '../model/quiz.dart';

const Map<String, String> UNIT_ID = foundation.kReleaseMode? {
  'android': 'ca-app-pub-2917734040573161/1953416706',
}: {
  'android' : 'ca-app-pub-3940256099942544/6300978111',
};


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int? _baseCategory;

  Widget showQuiz(Quiz quiz){
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
          Text(quiz.answer),
        ],
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('닫기'))
      ],
    );

    return alertDialog;
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
          TextFormField(
            maxLines: 2,
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
        TextButton(onPressed: (){
          Navigator.pop(context);
          showDialog(context: context, builder: (BuildContext context){
            return showQuiz(quiz);
          });
        }, child: Text('정답보기')),
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
                actions: [
                  TextButton(onPressed: (){Navigator.pop(context);}, child: Text('닫기')),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                    showDialog(context: context, builder: (BuildContext context){
                      return showQuiz(quiz);
                    });
                  }, child: Text('정답보기'),)
                ],
              );
            });
          }
        }, child: Text('제출')),
      ],
    );

    return alertDialog;
  }

  void updateBaseCategory(int? categoryId) async{
    await HistoryRepository.updateBaseCategory(categoryId);
    update();
  }

  Future<History?> _loadHistory() async{
    History? history = await HistoryRepository.getHistory();
    if(history != null){
      _baseCategory = history.baseCategory;
    }

    return history;
  }

  Future<Quiz?> findRandomQuizFromCategory(int? categoryId) async{
    if(categoryId == null){
      return null;
    }
    List<Quiz> quizzes = await QuizRepository.findAllByCategoryId(categoryId);
    if(quizzes.isEmpty){
      return null;
    }

    return quizzes[Random().nextInt(quizzes.length)];
  }

  void _makeHistory() async{
    History history = History(lastDate: DateTime.now(), continued: 1);
    await HistoryRepository.save(history);
    update();
  }

  void _updateHistory(DateTime lastDate, int continued) async{
    await HistoryRepository.update(lastDate, continued);
    update();
  }

  void createCategory(String name) async{
    Category category = Category(name: name);
    await CategoryRepository.save(category);
    update();
  }

  Future<List<Category>> _loadCategoryList() async{
    return await CategoryRepository.getList();
  }

  void updateCategory(int id, String name) async{
    await CategoryRepository.updateById(id, name);
    update();
  }

  void deleteCategory(int? id) async{
    await CategoryRepository.deleteById(id);
    update();
  }



  void update() => setState(() {});

  Widget _category(Category category){
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(category.name),
            onTap: () async {
              await Navigator.push(context,
                MaterialPageRoute(builder: (context) => QuizListView(category: category))
              );
            },
          ),
        ),
        IconButton(onPressed: (){
          if(_baseCategory == category.id){
            updateBaseCategory(null);
          }else{
            updateBaseCategory(category.id!);
          }
        }, icon: (category.id == _baseCategory) ? Icon(Icons.check_box_outlined) : Icon(Icons.check_box_outline_blank_outlined)
        ),
        IconButton(
            onPressed: (){
              String? inputText;
              AlertDialog alertDialog = AlertDialog(
                title: Text('변경할 이름을 입력하세요.'),
                content: TextFormField(
                  onChanged: (value) => inputText = value,
                  initialValue: category.name,
                ),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('취소')),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                    updateCategory(category.id!, inputText!);
                  }, child: Text('변경')),
                ],
              );
              showDialog(context: context, builder: (BuildContext context){
                return alertDialog;
              });
            }, 
            icon: const Icon(Icons.edit)
        ),
        IconButton(
          onPressed: () {
            AlertDialog alertDialog = AlertDialog(
              title: Text('정말로 삭제하시겠습니까?'),
              content: Text('카테고리의 모든 문제가 삭제됩니다.'),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('취소')),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                  deleteCategory(category.id);
                }, child: Text('삭제')),
              ],
            );
            showDialog(context: context, builder: (BuildContext context){
              return alertDialog;
            });
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      History? history = await HistoryRepository.getHistory();
      if(history == null) { // 첫 접속
        _makeHistory();
        return;
      }

      int? baseCategory = history.baseCategory;
      Quiz? quiz = await findRandomQuizFromCategory(baseCategory);

      if(!mounted) return;
      showDialog(context: context, builder: (BuildContext context) {
        if(quiz == null) {
          return AlertDialog(
            content: Text(
              '1. 카테고리 추가(하단 좌측)\n'
              '2. 카테고리 이동 후 문제 추가\n'
              '3. 기본 카테고리 설정(체크박스 체크)'
            ),
          );
        }
        return solveQuiz(quiz);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
        size: AdSize.banner,
        adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
        listener: BannerAdListener(
          onAdFailedToLoad: (Ad ad, LoadAdError error) {},
          onAdLoaded: (_) {},
        ),
        request: AdRequest(),
    )..load();

    var scat = Scaffold(
      appBar: AppBar(
        title: Text('리마인더'),
      ),
      body: FutureBuilder<List<Category>>(
        future: _loadCategoryList(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(
              // child: Text('오류'),
            );
          }
          if(snapshot.hasData){
            var datas = snapshot.data;
            return ListView(
              children: List.generate(datas!.length, (index) => _category(datas[index])),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      floatingActionButton: FutureBuilder<History?>(
        future: _loadHistory(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('오류');
          }
          if(snapshot.hasData){
            var history = snapshot.data;
            DateTime now = DateTime.now();
            DateTime today = DateTime(now.year, now.month, now.day);

            DateTime lastDate = history!.lastDate;
            DateTime lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);

            // !첫 접속& 날짜 바뀌고 접속
            if(today.difference(lastDay).inDays != 0){
              // 연속 접속
              if(today.difference(lastDay).inDays <= 1){
                _updateHistory(now, history.continued + 1);
              }else{ // 연속 접속 끝
                _updateHistory(now, 1);
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (){
                    AlertDialog alertDialog = AlertDialog(
                      content: Text(
                          '에빙하우스 망각곡선에 따르면 초반에는 쉽게 잊혀지지만,\n자주 볼수록 잊혀지지 않는 장기 기억이 된다고 합니다!'
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text('닫기')),
                      ],
                    );
                    showDialog(context: context, builder: (BuildContext context){
                      return alertDialog;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Text('${history.continued} 일 연속으로 복습 중', style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          }else{
            // 첫 접속
            _makeHistory();
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar:  BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(onPressed: (){
              String? inputText;
              AlertDialog alertDialog = AlertDialog(
                title: Text('새 카테고리의 이름을 입력해주세요.'),
                content: TextField(
                  onChanged: (value) => inputText = value,
                ),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('취소')),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                    if(inputText != null){
                      createCategory(inputText!);
                    }
                  }, child: Text('생성')),
                ],
              );
              showDialog(context: context, builder: (BuildContext context){
                return alertDialog;
              });
            }, child: Text('카테고리 추가',
              style: TextStyle(color: Colors.black),)),
            TextButton(onPressed: () async {
              Quiz? quiz = await findRandomQuizFromCategory(_baseCategory);
              if(!mounted) return;
              if(quiz == null){
                showDialog(context: context, builder: (BuildContext context){
                  String msg = '카테고리에 문제를 하나 이상 추가해주세요.';
                  if(_baseCategory == null){
                    msg = '기본 카테고리를 선택해주세요.\n(카테고리명 우측 체크 박스 체크)';
                  }
                  return AlertDialog(
                    content: Text(msg),
                  );
                });
              }else{
                showDialog(context: context, builder: (BuildContext context){
                  return solveQuiz(quiz);
                });
              }

            }, child: Text('랜덤 풀기',
              style: TextStyle(color: Colors.black),)),
          ],
        ),
      ),
    );

    // return scat;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: scat),
        SizedBox(
          height: 5,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.blue),
          ),
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: AdWidget(ad: banner),
        ),
      ],
    );
  }
}
