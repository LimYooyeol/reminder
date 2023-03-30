import 'package:flutter/material.dart';
import 'package:reminder/model/category.dart';
import 'package:reminder/repository/CategoryRepository.dart';
import 'package:reminder/view/quiz_list_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder'),
      ),
      body: FutureBuilder<List<Category>>(
        future: _loadCategoryList(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(
              child: Text('오류'),
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
      floatingActionButton: TextButton(
        onPressed: (){
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
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Text('카테고리 추가', style: TextStyle(color: Colors.white),),
      ),
      floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
    );
  }
}
