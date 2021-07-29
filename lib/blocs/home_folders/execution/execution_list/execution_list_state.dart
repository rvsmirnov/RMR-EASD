part of 'execution_list_bloc.dart';

abstract class ExecutionListState extends Equatable {
  const ExecutionListState();

  @override
  List<Object?> get props => [];
}

class ExecutionListInitial extends ExecutionListState {}

class ExecutionListLoading extends ExecutionListState {}

class ExecutionListSortInit extends ExecutionListState {
  final List<SortColumnDetails>? sortDataList;

  const ExecutionListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'ExecutionListSortInit { sortDataList: $sortDataList }';

}

class ExecutionListFailure extends ExecutionListState {
  final String? error;

  const ExecutionListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'ExecutionListFailure { error: $error }';
}
