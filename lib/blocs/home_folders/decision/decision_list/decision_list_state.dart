part of 'decision_list_bloc.dart';

abstract class DecisionListState extends Equatable {
  const DecisionListState();

  @override
  List<Object?> get props => [];
}

class DecisionListInitial extends DecisionListState {}

class DecisionListLoading extends DecisionListState {}

class DecisionListSortInit extends DecisionListState {
  final List<SortColumnDetails>? sortDataList;

  const DecisionListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'DecisionListSortInit { sortDataList: $sortDataList }';

}

class DecisionListFailure extends DecisionListState {
  final String? error;

  const DecisionListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'DecisionListFailure { error: $error }';
}
