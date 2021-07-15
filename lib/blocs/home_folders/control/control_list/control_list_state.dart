part of 'control_list_bloc.dart';

abstract class ControlListState extends Equatable {
  const ControlListState();

  @override
  List<Object?> get props => [];
}

class ControlListInitial extends ControlListState {}

class ControlListLoading extends ControlListState {}

class ControlListSortInit extends ControlListState {
  final List<SortColumnDetails>? sortDataList;

  const ControlListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'ControlListSortInit { sortDataList: $sortDataList }';

}

class ControlListFailure extends ControlListState {
  final String? error;

  const ControlListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'ControlListFailure { error: $error }';
}
