import 'package:flutter/material.dart';
import 'package:practice_interview/home.dart';
import 'package:provider/provider.dart';
import 'package:practice_interview/provider_task.dart';


void main() {
  runApp(ChangeNotifierProvider(create: (context)=> ProviderTask(),
  child: MyApp())
  
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}