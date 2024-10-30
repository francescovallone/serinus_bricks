import 'package:serinus/serinus.dart';

import 'todo.dart';

class AppController extends Controller {

  AppController({super.path = '/'}){
    on(Route.get('/'), _getAllTodos);
    on(Route.get('/<index>'), _getTodo);
    on(Route.put('/<index>'), _toggleTodo);
  }

  Future<List<Todo>> _getAllTodos(RequestContext context) async {
    return context.provider<AppProvider>().todos;
  }

  Future<Todo> _getTodo(RequestContext context) async {
    final index = int.tryParse(context.params['index'] ?? '');
    if (index == null) {
      throw BadRequestException('Invalid index');
    }
    final todos = context.provider<AppProvider>().todos;
    if (todos.isEmpty || index < 0 || index >= todos.length) {
      throw NotFoundException('Todo not found');
    }
    return todos[index];
  }

  Future<Todo> _toggleTodo(RequestContext context) async {
    final index = int.tryParse(context.params['index'] ?? '');
    if (index == null) {
      throw BadRequestException('Invalid index');
    }
    context.provider<AppProvider>().toggleTodoStatus(index);
    return context.provider<AppProvider>().todos[index];
  }


}