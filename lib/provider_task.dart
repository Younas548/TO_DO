import 'dart:convert';
import 'dart:async';   // TimeoutException ke liye
import 'dart:io';      // SocketException ke liye

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_interview/practice.dart';

enum ScreenState {loading , success, error,empty}
class ProviderTask extends ChangeNotifier{
  
  

  List<Task> _tasks = [
    // Task(id: DateTime.now().toString(), title: "Flutter Developer", isDone: false, createdAt: DateTime.now()),
    // Task(id: DateTime.now().toString(), title: "Firebase", isDone: false, createdAt: DateTime.now())
  ];
  ScreenState _state = ScreenState.loading;
  ScreenState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
List<Task> get task => _tasks;
Future<void> fetchTask() async {
  _state = ScreenState.loading;
  notifyListeners();
  try{
        final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=10'));
        if(response.statusCode == 200){
          final List<dynamic> data = jsonDecode(response.body);
          _tasks = data.map((json) => Task.fromJson(json)).toList();

          if(_tasks.isEmpty){
            _state = ScreenState.empty;
          }else{
            _state = ScreenState.success;
          }
        }else{
          _state = ScreenState.error;
          _errorMessage = 'Faild to load Tasks ${response.statusCode}';
        }
  }on SocketException{
    _state=ScreenState.error;
    _errorMessage ='INTERNET CHECK KRO ';
  }on TimeoutException{
    _state = ScreenState.error;
    _errorMessage = 'Request Time Out Plz try agin';
  }on FormatException{
    _state = ScreenState.error;
    _errorMessage = 'Server na glt data beja ';
  }
  
   catch (e) {
    _state = ScreenState.error;
    _errorMessage = 'An error has oucured $e';
}
notifyListeners();
}
// void addTask(String title){
//   _tasks.add(
//     Task(id: DateTime.now().toString(), title: "Backend Developer", isDone: false, createdAt: DateTime.now())
//   );
//   _state = ScreenState.success;
//   notifyListeners();
// }
void addTask(String title){
  _tasks.add(
    Task(id: DateTime.now().toString(), title: title, isDone: false, createdAt: DateTime.now())
  );
  _state = ScreenState.success;
  notifyListeners();
}
void removeTask(Task task){
  _tasks.remove(task);
  notifyListeners();
}
void toggleTask(int index , bool value){
  _tasks[index].isDone = value;
  notifyListeners();
}
}
