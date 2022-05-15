import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/todo.dart';

const todoListkey = 'todo_list';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListkey) ?? '[]';
    final List jsondecoded = jsonDecode(jsonString) as List;
    return jsondecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final String jasonString = json.encode(todos);
    sharedPreferences.setString(todoListkey, jasonString);
  }
}
