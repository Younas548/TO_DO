import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_interview/detail.dart';
import 'package:practice_interview/main.dart';
import 'package:practice_interview/provider_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProviderTask>().fetchTask());
  }

  void _addTask(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paper,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('New task', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(hintText: 'What needs doing?'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Title can't be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.inkMuted,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context
                                .read<ProviderTask>()
                                .addTask(titleController.text.trim());
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add task'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        title: Consumer<ProviderTask>(
          builder: (context, taskProvider, child) {
            final tasks = taskProvider.task;
            final done = tasks.where((t) => t.isDone).length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Today'),
                if (taskProvider.state == ScreenState.success)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$done of ${tasks.length} done',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      body: Consumer<ProviderTask>(
        builder: (context, taskProvider, child) {
          switch (taskProvider.state) {
            case ScreenState.loading:
              return const _LoadingView();

            case ScreenState.error:
              return _ErrorView(
                message: taskProvider.errorMessage,
                onRetry: () => taskProvider.fetchTask(),
              );

            case ScreenState.empty:
              return const _EmptyView();

            case ScreenState.success:
              final tasks = taskProvider.task;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: tasks.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final currentTask = tasks[index];
                  return _TaskRow(
                    title: currentTask.title,
                    isDone: currentTask.isDone,
                    onToggle: (value) =>
                        taskProvider.toggleTask(index, value),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(task: currentTask),
                        ),
                      );
                      if (result == true) {
                        taskProvider.removeTask(currentTask);
                      }
                    },
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addTask(context),
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }
}

// Ek row: ledger jaisa hairline-separated task, custom circle checkbox
class _TaskRow extends StatelessWidget {
  final String title;
  final bool isDone;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const _TaskRow({
    required this.title,
    required this.isDone,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => onToggle(!isDone),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.pine : Colors.transparent,
                  border: Border.all(
                    color: isDone ? AppColors.pine : AppColors.line,
                    width: 1.5,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: AppColors.paper)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration:
                          isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? AppColors.inkMuted : AppColors.ink,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.pine),
          const SizedBox(height: 16),
          Text('Loading your tasks…', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit_note, size: 40, color: AppColors.inkMuted),
            const SizedBox(height: 12),
            Text(
              'Nothing on your list yet',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Add your first task to get started.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.clay),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 140,
              child: OutlinedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}