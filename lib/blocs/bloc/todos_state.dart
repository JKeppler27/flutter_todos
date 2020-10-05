part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();
  
  @override
  List<Object> get props => [];
}

class TodosLoadInProgress extends TodosState {}

class TodosLoadSuccessful extends TodosState {
  final List<Todo> todos;

  const TodosLoadSuccessful([this.todos = const []]);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'ToddosLoadSuccess { todos: $todos }';
}

class TodosLoadFailure extends TodosState {}
