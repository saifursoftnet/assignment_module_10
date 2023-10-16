import 'package:flutter/material.dart';
import 'package:assignment_10/validation.dart';
import 'package:assignment_10/edit_task.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreenState(),
      debugShowCheckedModeBanner: false,
      title: "App",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.blue,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFff5151),
          ),
        ),
      ),
    );
  }

}

class HomeScreenState extends StatefulWidget {
  const HomeScreenState({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenUI();

}

class HomeScreenUI extends State<HomeScreenState> {

  List<Items> itemList = [];

  final TextEditingController _textFieldOneEDController = TextEditingController();
  final TextEditingController _textFieldTwoEDController = TextEditingController();
  final GlobalKey<FormState> _formControllerKey =   GlobalKey<FormState>();

  void addTaskItem() {
    Items items = Items(title: _textFieldOneEDController.text, description: _textFieldTwoEDController.text);
    itemList.add(items);
    _textFieldOneEDController.text = '';
    _textFieldTwoEDController.text = '';
    setState(() {});
  }

  void taskItemDelete(int index) {
    itemList.removeAt(index);
    Navigator.pop(context);
    setState(() {});
  }

  void taskItemUpdate(int index, String title, String description) {
    itemList[index].title = title;
    itemList[index].description = description;
    Navigator.pop(context);
    setState(() {});
  }

  AlertDialog onLongPressItemAlert(int index) {
    return AlertDialog(
      title: const Text("Alert"),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.pop(context);
              showModalBottomSheet(context: context, builder: (context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EditTaskUpdate(index: index, title: itemList[index].title, description: itemList[index].description, taskItemUpdate: (index, title, description){
                    taskItemUpdate(index, title, description);
                  },),
                );
              });
            },
            child: const Text("Edit")),
        TextButton(
            onPressed: (){
              taskItemDelete(index);
            },
            child: const Text("Delete")),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formControllerKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextFormField(
                controller: _textFieldOneEDController,
                decoration: const InputDecoration(
                    hintText: "Add Title",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    )
                ),
                validator: (String? value){
                  return Validation.checkInputValidation(value, "Please add a title");
                },
              ),
              const SizedBox(height: 8,),
              TextFormField(
                controller: _textFieldTwoEDController,
                decoration: const InputDecoration(
                    hintText: "Add Description",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    )
                ),
                validator: (String? value){
                  return Validation.checkInputValidation(value, "Please add a description");
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: (){
                    if(_formControllerKey.currentState!.validate()) {
                      addTaskItem();
                    }
                  },
                  child: const Text("Add")),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index){
                    return Card(
                      color: Colors.grey.shade300,
                      child: ListTile(
                        onLongPress: (){
                          showDialog(context: context, builder: (context) {
                            return onLongPressItemAlert(index);
                          });
                        },
                        leading: const CircleAvatar(backgroundColor: Color(0xFFff5151),),
                        title: Text(itemList[index].title),
                        subtitle: Text(itemList[index].description),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Items {
  late String title, description;
  Items({required this.title, required this.description});
}