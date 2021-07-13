part of 'decision_list_bloc.dart';

abstract class DecisionListEvent extends Equatable {
  const DecisionListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends DecisionListEvent {}

class SortDataSave extends DecisionListEvent {
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


