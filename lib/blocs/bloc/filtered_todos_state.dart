part of 'filtered_todos_bloc.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();
  
  @override
  List<Object> get props => [];
}

class FilteredTodosLoadInProgress extends FilteredTodosState {}

class FilteredTodosLoadSuccessful extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;

  const FilteredTodosLoadSuccessful(
    this.filteredTodos,
    this.activeFilter,
  );

  @override
  List<Object> get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoadSuccessful { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}
