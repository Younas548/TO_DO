import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_interview/practice.dart';
import 'package:practice_interview/provider_task.dart';
import 'package:practice_interview/detail.dart';
//import 'task_details_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState(){
    super.initState();
    Future.microtask(()=> context.read<ProviderTask>().fetchTask());
  }
  void _addTask(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Form(
            key: _formkey,
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Add Task'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "title khali nhi ho sakta";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  // Provider ke zariye task add karo, listen: false zaroori hai
                  context.read<ProviderTask>().addTask(_titleController.text);
                  _titleController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Consumer<ProviderTask>(
        builder: (context, taskProvider, child) {
           switch (taskProvider.state){
            case ScreenState.loading:
            return const Center(child: CircularProgressIndicator());

            case ScreenState.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                    Text(taskProvider.errorMessage),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: (){
                      taskProvider.fetchTask();
                    }, child: Text("Retry"))
                  
                ],
              ),
            );
            case ScreenState.empty:
                return const Text("No task yet");
            case ScreenState.success:
              
          final tasks = taskProvider.task;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index].title),
                leading: Checkbox(
                  value: tasks[index].isDone,
                  onChanged: (bool? value) {
                    taskProvider.toggleTask(index, value ?? false);
                  },
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(task: tasks[index]),
                    ),
                  );

                  if (result == true) {
                    taskProvider.removeTask(tasks[index]);
                  }
                },
              );
            },
          );

           }

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}