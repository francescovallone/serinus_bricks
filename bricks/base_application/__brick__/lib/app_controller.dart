import 'package:serinus/serinus.dart';

import 'app_provider.dart';
import 'todo.dart';

class AppController extends Controller {

  AppController({super.path = '/'}){
    on(Route.get('/'), _getAllTodos);
    on(Route.get('/<index>'), _getTodo);
    on(Route.post('/') , _createTodo);
    on(Route.put('/<index>'), _toggleTodo);
    on(Route.delete('/<index>'), _removeTodo);
  }

  Future<List<Todo>> _getAllTodos(RequestContext context) async {
    return context.use<AppProvider>().todos;
  }

  Future<Todo> _getTodo(RequestContext context) async {
    final index = int.tryParse(context.params['index'] ?? '');
    if (index == null) {
      throw BadRequestException(message: 'Invalid index');
    }
    final todos = context.use<AppProvider>().todos;
    if (todos.isEmpty || index < 0 || index >= todos.length) {
      throw NotFoundException(message: 'Todo not found');
    }
    return todos[index];
  }

  Future<Todo> _toggleTodo(RequestContext context) async {
    final index = int.tryParse(context.params['index'] ?? '');
    if (index == null) {
      throw BadRequestException(message: 'Invalid index');
    }
    context.use<AppProvider>().toggleTodoStatus(index);
    return context.use<AppProvider>().todos[index];
  }

  Future<Todo> _createTodo(RequestContext context) async {
    final body = context.body.json;
    if (body == null || body['title'] == null) {
      throw BadRequestException(message: 'Invalid request body');
    }
    final title = body['title'] as String;
    context.use<AppProvider>().addTodo(title);
    return context.use<AppProvider>().todos.last;
  }

  Future<void> _removeTodo(RequestContext context) async {
    final index = int.tryParse(context.params['index'] ?? '');
    if (index == null) {
      throw BadRequestException(message: 'Invalid index');
    }
    context.use<AppProvider>().removeTodoAt(index);
  }


}