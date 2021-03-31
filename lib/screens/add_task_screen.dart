import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/models/todo.dart';
import 'package:flutter_todo_demo/utils/dbhelper.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Todo todo;

  AddTaskScreen(this.todo);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState(todo);
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final Todo todo;
  final _formKey = GlobalKey<FormState>();
  String _title, _description, _priority;
  DateTime _date = DateTime.now();
  final DateFormat dateFormat = DateFormat('MMM dd, yyyy');

  TextEditingController _dateController = TextEditingController();
  final List<String> _priorities = ["Low", "Medium", "High"];

  _AddTaskScreenState(this.todo);

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = dateFormat.format(date);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_date, $_priority');

      if (todo?.id == null) {
        var todo = Todo(_title, _date.toString(), _priority, 0, _description);
        var result = await DBHelper.instance.insertTodo(todo);
        print("Data inserted successfully! id = $result");
      } else {
        todo.title = _title;
        todo.description = _description;
        todo.date = _date.toString();
        todo.priority = _priority;
        var result = await DBHelper.instance.updateTodo(todo);
        print("Data updated successfully! id = $result");
      }
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    if (todo != null) {
      _title = todo.title;
      _description = todo.description;
      _date = DateTime.parse(todo.date);
      _dateController.text = dateFormat.format(_date);
      _priority = todo.priority;
    } else {
      _dateController.text = dateFormat.format(_date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _taskTitle(),
                  _taskDescription(),
                  _taskDatePicker(),
                  _taskPriorityDropdown(),
                  _taskSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _taskTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: TextFormField(
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          labelText: 'Title',
          hintText: 'Task Title',
          labelStyle: TextStyle(fontSize: 18.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter a task title.' : null,
        onSaved: (input) => _title = input,
        initialValue: _title,
      ),
    );
  }

  Widget _taskDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: TextFormField(
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Task Description',
          labelStyle: TextStyle(fontSize: 18.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter a task description.' : null,
        onSaved: (input) => _description = input,
        initialValue: _description,
      ),
    );
  }

  Widget _taskDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: TextFormField(
        readOnly: true,
        controller: _dateController,
        onTap: _handleDatePicker,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          labelText: 'Date',
          hintText: 'Task Date',
          labelStyle: TextStyle(fontSize: 18.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _taskPriorityDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: DropdownButtonFormField(
        icon: Icon(Icons.arrow_drop_down_circle),
        iconEnabledColor: Theme.of(context).primaryColor,
        items: _priorities.map((String priority) {
          return DropdownMenuItem(
            value: priority,
            child: Text(
              priority,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          );
        }).toList(),
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          labelText: 'Priority',
          hintText: 'Task Priority',
          labelStyle: TextStyle(fontSize: 18.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (input) =>
            _priority == null ? 'Please select a priority level.' : null,
        onSaved: (input) => _priority = input,
        onChanged: (value) {
          setState(() {
            _priority = value;
          });
        },
        value: _priority,
      ),
    );
  }

  Widget _taskSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: Container(
        height: 60.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: FlatButton(
          child: Text(
            todo == null ? 'Add' : 'Update',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: _submit,
        ),
      ),
    );
  }
}
