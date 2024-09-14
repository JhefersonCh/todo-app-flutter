// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/task_provider.dart';
import 'models/task.dart';
import 'screens/detail_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final allSelected =
        tasks.isNotEmpty && tasks.every((task) => task.isCompleted);

    Future<void> refreshTasks() async {
      await ref.read(taskProvider.notifier).refreshTasks();
    }

    void showEditTaskDialog(BuildContext context, Task task, WidgetRef ref) {
      String updatedTitle = task.title;
      String updatedDescription = task.description;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Editar Tarea'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    updatedTitle = value;
                  },
                  controller: TextEditingController(text: task.title),
                  decoration:
                      const InputDecoration(hintText: 'Título de la tarea'),
                ),
                TextField(
                  onChanged: (value) {
                    updatedDescription = value;
                  },
                  controller: TextEditingController(text: task.description),
                  decoration: const InputDecoration(
                      hintText: 'Descripción de la tarea'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Actualizar la tarea si el título o descripción cambiaron
                  if (updatedTitle.isNotEmpty) {
                    ref.read(taskProvider.notifier).editTask(
                          task.id,
                          updatedTitle,
                          updatedDescription,
                        );
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (tasks.length > 1)
            Row(
              children: [
                const Text('Sel. todos',
                    style:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                Checkbox(
                  value: allSelected,
                  onChanged: (_) {
                    _toggleSelectAllTasks(ref);
                  },
                  side: const BorderSide(
                    color: Colors.white, // Borde blanco
                    width: 2.0, // Ancho del borde
                  ),
                ),
              ],
            ),
        ],
        backgroundColor: const Color.fromARGB(241, 43, 114, 185),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshTasks(),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (_) {
                  ref.read(taskProvider.notifier).toggleTaskCompletion(task.id);
                },
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'edit') {
                    showEditTaskDialog(context, task, ref);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Editar'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(task: task),
                  ),
                );
              },
            );
          },
        ),
      ),
      // Botones flotantes: uno para agregar tarea y otro para eliminar tareas completadas
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón flotante para eliminar tareas completadas
          if (tasks.any((task) => task.isCompleted))
            FloatingActionButton(
              heroTag: 'delete',
              onPressed: () {
                _showDeleteTaskDialog(context, ref);
              },
              backgroundColor: Colors.red,
              tooltip: 'Eliminar tareas completadas',
              child: const Icon(Icons.delete),
            ),
          const SizedBox(height: 10),
          // Botón flotante para agregar una nueva tarea
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              _showAddTaskDialog(context, ref);
            },
            tooltip: 'Agregar nueva tarea',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  // Función para mostrar el diálogo de agregar tarea
  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        String taskTitle = '';
        String taskDescription = '';
        return AlertDialog(
          title: const Text('Agregar Nueva Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  taskTitle = value;
                },
                decoration:
                    const InputDecoration(hintText: 'Título de la tarea'),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  taskDescription = value;
                },
                decoration:
                    const InputDecoration(hintText: 'Descripción de la tarea'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  ref.read(taskProvider.notifier).addTask(
                        Task(
                            id: DateTime.now().toString(),
                            title: taskTitle,
                            description: taskDescription),
                      );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Funcion para mostrar el dialogo para eliminación de la tarea
  void _showDeleteTaskDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Tarea'),
          content: const Text(
              '¿Estás seguro que deseas eliminar las tareas completadas?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                ref.read(taskProvider.notifier).removeCompletedTasks();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelectAllTasks(WidgetRef ref) {
    final tasks = ref.read(taskProvider);
    final allCompleted = tasks.every((task) => task.isCompleted);

    ref.read(taskProvider.notifier).state = [
      for (final task in tasks)
        Task(
          id: task.id,
          title: task.title,
          description: task.description,
          isCompleted: !allCompleted,
        )
    ];
  }
}
