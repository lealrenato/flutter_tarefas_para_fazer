import 'package:flutter/material.dart';
import 'package:flutter_application_1/modelos/todo.dart';
import 'package:flutter_application_1/repositories/todo_repository.dart';
import 'package:flutter_application_1/widgets/todo_list_itens.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController todosController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPosition;

  String? errorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todosController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Ex.: Comprar maçãs',
                        errorText: errorText,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String text = todosController.text;
                      if (text.isEmpty) {
                        setState(() {
                          errorText = 'A tarefa não pode ser vasia';
                        });
                        return;
                      }

                      setState(() {
                        Todo newTodo = Todo(
                          subtitle: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(newTodo);
                        errorText = null;
                      });

                      todosController.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    child: Text(
                      "+",
                      style: TextStyle(fontSize: 35),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(50, 60),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "você possui ${todos.length} tarefas pendentes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  ElevatedButton(
                      onPressed: showDeleteTodoConfirmationDialog,
                      child: Text("Limpar Tudo"))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPosition = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa  ${todo.subtitle}foi removida com sucesso!',
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: "Desfazer",
            textColor: Colors.blue,
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoPosition!, deletedTodo!);
              });
            }),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text("Você tem certeza que deseja remover todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(primary: Colors.blue),
            child: Text("Cancelar"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              style: TextButton.styleFrom(primary: Colors.red),
              child: Text("Limpar Tudo")),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos = [];
    });
    todoRepository.saveTodoList(todos);
  }
}
