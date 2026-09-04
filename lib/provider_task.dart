import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_interview/practice.dart';

enum ScreenState { loading, success, error, empty }

class ProviderTask extends ChangeNotifier {
  List<Task> _tasks = [];

  ScreenState _state = ScreenState.loading;
  ScreenState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Task> get task => _tasks;

  Future<void> fetchTask() async {
    _state = ScreenState.loading;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse(
              'https://jsonplaceholder.typicode.com/todos?_limit=10'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _tasks = data.map((json) => Task.fromJson(json)).toList();
        _state = _tasks.isEmpty ? ScreenState.empty : ScreenState.success;
      } else {
        _state = ScreenState.error;
        _errorMessage = 'Server error (${response.statusCode}). Please try again.';
      }
    } on SocketException {
      _state = ScreenState.error;
      _errorMessage = 'No internet connection. Check your network and retry.';
    } on TimeoutException {
      _state = ScreenState.error;
      _errorMessage = 'The request timed out. Please try again.';
    } on FormatException {
      _state = ScreenState.error;
      _errorMessage = 'Received unexpected data from the server.';
    } catch (e) {
      _state = ScreenState.error;
      _errorMessage = 'Something went wrong: $e';
    }

    notifyListeners();
  }

  void addTask(String title) {
    _tasks.add(
      Task(
        id: DateTime.now().toString(),
        title: title,
        isDone: false,
        createdAt: DateTime.now(),
      ),
    );
    _state = ScreenState.success;
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    if (_tasks.isEmpty) {
      _state = ScreenState.empty;
    }
    notifyListeners();
  }

  void toggleTask(int index, bool value) {
    _tasks[index].isDone = value;
    notifyListeners();
  }
}