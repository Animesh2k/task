import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../data/models/task.dart';
import '../../data/repositories/task_repository.dart';
import '../../services/sync_service.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../../../../core/utill/toasts.dart';
import '../../../../main.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late final TaskBloc _taskBloc;
  late final String _userId;

  @override
  void initState() {
    super.initState();
    _userId = Get.find<AuthController>().firebaseUser.value?.uid ?? '';
    _taskBloc = TaskBloc(
      taskRepository: TaskRepository(database: objectBox),
      syncService: SyncService(
        taskRepository: TaskRepository(database: objectBox),
      ),
    )..add(LoadTasksEvent(userId: _userId));
  }

  @override
  void dispose() {
    _taskBloc.close();
    super.dispose();
  }

  Future<void> _navigateTo(BuildContext context, String path) async {
    await context.push(path);
    if (mounted) {
      _taskBloc.add(LoadTasksEvent(userId: _userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return BlocProvider.value(
      value: _taskBloc,
      child: OfflineBuilder(
        connectivityBuilder:
            (
              BuildContext context,
              List<ConnectivityResult> connectivity,
              Widget child,
            ) {
              final bool isOffline = connectivity.contains(
                ConnectivityResult.none,
              );

              return Scaffold(
                backgroundColor: background,
                body: Stack(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [
                          _buildHeader(context, isOffline, isDark, textColor),
                          Expanded(
                            child: BlocBuilder<TaskBloc, TaskState>(
                              builder: (context, state) {
                                if (state is TaskLoading) {
                                  return _buildLoading(
                                    context,
                                    state.tasks,
                                    isDark,
                                  );
                                } else if (state is TaskLoaded) {
                                  return _buildTaskList(
                                    context,
                                    state,
                                    _userId,
                                    isDark,
                                    textColor,
                                  );
                                } else if (state is TaskError) {
                                  return _buildError(state.message);
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isOffline)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.orange,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_off,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'You are offline',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _navigateTo(context, '/tasks/create'),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              );
            },
        child: const SizedBox(),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isOffline,
    bool isDark,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Tasks',
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded && state.unsyncedCount > 0) {
                return IconButton(
                  icon: Icon(Icons.sync, color: textColor),
                  onPressed: () {
                    context.read<TaskBloc>().add(SyncTasksEvent(_userId));
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context, List<Task> tasks, bool isDark) {
    if (tasks.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    }
    return _buildTaskList(
      context,
      TaskLoaded(tasks: tasks),
      '',
      isDark,
      isDark ? Colors.white : Colors.black,
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    TaskLoaded state,
    String userId,
    bool isDark,
    Color textColor,
  ) {
    final todoTasks = state.tasks
        .where((t) => t.status == TaskStatus.todo)
        .toList();
    final inProgressTasks = state.tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .toList();
    final completedTasks = state.tasks
        .where((t) => t.status == TaskStatus.completed)
        .toList();
    final surface = isDark ? Colors.grey[900]! : Colors.grey[100]!;

    if (state.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 80,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TaskBloc>().add(
          LoadTasksEvent(userId: userId, forceRefresh: true),
        );
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          if (todoTasks.isNotEmpty) ...[
            _buildSectionHeader('To Do', isDark),
            ...todoTasks.map(
              (task) => _buildTaskCard(
                context,
                task,
                userId,
                isDark,
                textColor,
                surface,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (inProgressTasks.isNotEmpty) ...[
            _buildSectionHeader('In Progress', isDark),
            ...inProgressTasks.map(
              (task) => _buildTaskCard(
                context,
                task,
                userId,
                isDark,
                textColor,
                surface,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (completedTasks.isNotEmpty) ...[
            _buildSectionHeader('Completed', isDark),
            ...completedTasks.map(
              (task) => _buildTaskCard(
                context,
                task,
                userId,
                isDark,
                textColor,
                surface,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (state.unsyncedCount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${state.unsyncedCount} tasks not synced',
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    Task task,
    String userId,
    bool isDark,
    Color textColor,
    Color surface,
  ) {
    final border = isDark ? Colors.white24 : Colors.black26;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusDropdown(
                context,
                task,
                userId,
                isDark,
                textColor,
                surface,
              ),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: textColor, size: 20),
                onPressed: () => _navigateTo(context, '/tasks/edit/${task.id}'),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () {
                  _showDeleteDialog(context, task.id, _userId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(
    BuildContext context,
    Task task,
    String userId,
    bool isDark,
    Color textColor,
    Color surface,
  ) {
    return DropdownButton<TaskStatus>(
      value: task.status,
      dropdownColor: surface,
      iconEnabledColor: textColor,
      style: TextStyle(color: textColor),
      underline: Container(height: 0),
      items: TaskStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status.displayName, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: (status) {
        if (status != null) {
          context.read<TaskBloc>().add(
            UpdateTaskStatusEvent(taskId: task.id, status: status),
          );
          AppToast.showSuccess('Task status updated');
        }
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String taskId, String userId) {
    final taskBloc = context.read<TaskBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              taskBloc.add(DeleteTaskEvent(taskId));
              AppToast.showSuccess('Task deleted');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
