import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveTasks(List<String> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
  }

  Future<List<String>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('tasks') ?? [];
  }
}
