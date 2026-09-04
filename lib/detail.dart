import 'package:flutter/material.dart';
import 'package:practice_interview/practice.dart';

class DetailScreen extends StatelessWidget {
  final Task task;
  const DetailScreen ({super.key ,required this.task});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Padding(padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title),
            SizedBox(height: 10),
            Text("Status ${task.isDone ? 'completed' : 'pending'}"),
            SizedBox(height: 10),
            Text("created ${task.createdAt}"),
            Spacer(),
            SizedBox(width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: (){
              Navigator.pop(context,true);
            }, child: Text("Delete")),)
          ],
        ),

      ),
    );
  }
}