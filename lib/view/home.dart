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

  void createCategory(int num) async{
    Category category = Category(name: '카테고리${num}');

    await CategoryRepository.save(category);
    update();
  }

  void update() => setState(() {});

  Widget _category(Category category){
    var categoryId = category.id;

    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizListView(
                categoryId: categoryId
            ))
        );
      },
      child:
      Container(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green)
                ),
                Text('질문${categoryId}')
              ],
            )
          ],
        ),
      ),
      // Child
    );
  }

  Future<List<Category>> _loadCategoryList() async{
    return await CategoryRepository.getList();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => createCategory(1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
