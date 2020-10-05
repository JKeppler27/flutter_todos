import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter_todos/blocs/blocs.dart';

import 'package:todos_repository_simple/todos_repository_simple.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepositoryFlutter todosRepository;

  TodosBloc({@required this.todosRepository}) : super(TodosLoadInProgress());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is TodosLoadSuccess) {
      yield* _mapTodosLoadedToState();
    } else if (event is TodoAdded) {
      yield* _mapTodoAddedToState(event);
    } else if (event is TodoUpdated) {
      yield* _mapTodoUpdatedToState(event);
    } else if (event is TodoDeleted) {
      yield* _mapTodoDeletedToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    }
  }

  Stream<TodosState> _mapTodosLoadedToState() async* {
    try {
      final todos = await this.todosRepository.loadTodos();
      yield TodosLoadSuccessful(
        todos.map(Todo.fromEntity).toList(),
      );
    } catch (_) {
      yield TodosLoadFailure();
    }
  }

  Stream<TodosState> _mapTodoAddedToState(TodoAdded event) async* {
    if (state is TodosLoadSuccessful) {
      final List<Todo> updatedTodos = List.from((state as TodosLoadSuccessful).todos)
        ..add(event.todo);
      yield TodosLoadSuccessful(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoUpdatedToState(TodoUpdated event) async* {
    if (state is TodosLoadSuccessful) {
      final List<Todo> updatedTodos = (state as TodosLoadSuccessful).todos.map((todo) {
        return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
      }).toList();
      yield TodosLoadSuccessful(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoDeletedToState(TodoDeleted event) async* {
    if (state is TodosLoadSuccessful) {
      final updatedTodos = (state as TodosLoadSuccessful)
        .todos
        .where((todo) => todo.id != event.todo.id)
        .toList();
      yield TodosLoadSuccessful(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    if (state is TodosLoadSuccessful) {
      final allComplete = (state as TodosLoadSuccessful).todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = (state as TodosLoadSuccessful)
        .todos.map((todo) => todo.copyWith(complete: !allComplete)).toList();
        yield TodosLoadSuccessful(updatedTodos);
        _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    if (state is TodosLoadSuccessful) {
      final List<Todo> updatedTodos = (state as TodosLoadSuccessful).todos.where((todo) => !todo.complete).toList();
      yield TodosLoadSuccessful(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Future _saveTodos(List<Todo> todos) {
    return todosRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }

}
