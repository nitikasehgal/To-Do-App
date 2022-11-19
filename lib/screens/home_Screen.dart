import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todoapp/constant/colors.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundtodo = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    _foundtodo = todosList;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Searchbox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          "All ToDo's!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      for (ToDo todoo in _foundtodo.reversed)
                        TodoItem(
                          todo: todoo,
                          ontodochanged: _handletodochange,
                          ondeleteitem: _deletetodoitem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0)
                    ],
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add a new todo item!")),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: tdBlue,
                        minimumSize: Size(60, 60),
                        elevation: 10),
                    child: Text(
                      "+",
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    onPressed: () {
                      _addTodoitem(_controller.text);
                    }),
              ),
            ]),
          )
        ],
      ),
    );
  }

  void _handletodochange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deletetodoitem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodoitem(String todo) {
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todo));
    });
    _controller.clear();
  }

  void _runfilter(String enteredkeyword) {
    List<ToDo> results = [];
    if (enteredkeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredkeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundtodo = results;
    });
  }

  Widget Searchbox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        onChanged: (value) => _runfilter(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: tdBlack,
              size: 20,
            ),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ],
      ),
    );
  }
}
