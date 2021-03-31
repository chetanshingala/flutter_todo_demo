import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/models/todo.dart';
import 'package:flutter_todo_demo/screens/add_task_screen.dart';
import 'package:flutter_todo_demo/utils/dbhelper.dart';
import 'package:intl/intl.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<Todo> todos;
  int count = 0;

  Widget _buildTask(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: () {
          navigateToDetailPage(this.todos[index]);
        },
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: getColor(todos[index].priority),
                  child: Text(
                    todos[index].priority[0],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todos[index].title,
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          todos[index].description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        SizedBox(height: 5.0),
                        Text(
                            '${DateFormat('dd MMM yyyy').format(DateTime.parse(todos[index].date))}'),
                      ],
                    ),
                  ),
                ),
                // Checkbox(
                //   onChanged: (value) {
                //     print(value);
                //   },
                //   activeColor: Theme.of(context).primaryColor,
                //   value: true,
                // ),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      //Delete item
                      var id = this.todos[index].id;
                      await DBHelper.instance.deleteTodo(id);
                      updateToDoList();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Item Deleted successfully!')));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToDetailPage([Todo todo]) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTaskScreen(todo ?? null),
        ));

    if (result == true) {
      updateToDoList();
    }
  }

  Color getColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
        break;
      case "Medium":
        return Colors.orange;
        break;
      case "Low":
        return Colors.green;
        break;
      default:
        return Colors.green;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void updateToDoList() {
    DBHelper.instance.getTodoList().then((list) {
      setState(() {
        todos = list;
        count = todos.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = [];
      updateToDoList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My ToDos'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          bool result = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddTaskScreen(null)));
          if (result == true) {
            updateToDoList();
          }
        },
      ),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return _buildTask(index);
        },
      ),
    );
  }
}
