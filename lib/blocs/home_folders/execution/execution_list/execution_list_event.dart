part of 'execution_list_bloc.dart';

abstract class ExecutionListEvent extends Equatable {
  const ExecutionListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends ExecutionListEvent {}

class SortDataSave extends ExecutionListEvent {
  final List<SortColumnDetails>? sortDataList;

  const SortDataSave({
    @required this.sortDataList,
  });
  
  @override
  List<Object?> get props => [sortDataList];
  
  @override
  String toString() =>
      'SortDataSave { sortDataList: $sortDataList }';
}


