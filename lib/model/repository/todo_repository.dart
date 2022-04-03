import 'package:yuruli/model/db/todo_database.dart';
import 'package:yuruli/model/entity/todo.dart';

class TodoRepository {
  late final TodoDatabase _todoDatabase;

  TodoRepository(this._todoDatabase);

  Future<List<Todo>> loadTodos(String state) => _todoDatabase.loadTodos(state);

  Future update(Todo todo) => _todoDatabase.update(todo);

  Future insert(Todo todo) => _todoDatabase.insert(todo);

  Future delete(Todo todo) => _todoDatabase.delete(todo);
}
