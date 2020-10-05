import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilteredTodosBloc({@required this.todosBloc}) 
    : super(
      todosBloc.state is TodosLoadSuccess
        ? FilteredTodosLoadSuccess(
          (todosBloc.state as TodosLoadSuccess).todos,
          VisibilityFilter.all,
        )
        : FilteredTodosLoadInProgress(),
    ) {}

  @override
  Stream<FilteredTodosState> mapEventToState(
    FilteredTodosEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
