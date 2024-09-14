import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

// Proveedor para el estado de las tareas
final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

// Notificador para manejar el estado de las tareas
class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  // Agregar una tarea
  void addTask(Task task) {
    state = [...state, task];
  }

  // Alternar la finalización de una tarea
  void toggleTaskCompletion(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          Task(
            id: task.id,
            title: task.title,
            description: task.description,
            isCompleted: !task.isCompleted,
          )
        else
          task
    ];
  }

  // Eliminar tareas completadas
  void removeCompletedTasks() {
    state = state.where((task) => !task.isCompleted).toList();
  }

  // Recargar tareas (simulación de obtención de datos)
  Future<void> refreshTasks() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void editTask(String id, String newTitle, String newDescription) {
    state = [
      for (final task in state)
        if (task.id == id)
          Task(
            id: task.id,
            title: newTitle,
            description: newDescription,
            isCompleted: task.isCompleted,
          )
        else
          task
    ];
  }
}
