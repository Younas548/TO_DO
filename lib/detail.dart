import 'package:flutter/material.dart';
import 'package:practice_interview/main.dart';
import 'package:practice_interview/practice.dart';

class DetailScreen extends StatelessWidget {
  final Task task;
  const DetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: task.isDone ? AppColors.pineTint : AppColors.paper,
                border: Border.all(
                  color: task.isDone ? AppColors.pine : AppColors.line,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                task.isDone ? 'Completed' : 'Pending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: task.isDone ? AppColors.pine : AppColors.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Text(
              'Created',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              task.createdAt != null ? task.createdAt.toString() : 'Unknown',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}