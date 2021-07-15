part of 'acquaintance_list_bloc.dart';

abstract class AcquaintanceListState extends Equatable {
  const AcquaintanceListState();

  @override
  List<Object?> get props => [];
}

class AcquaintanceListInitial extends AcquaintanceListState {}

class AcquaintanceListLoading extends AcquaintanceListState {}

class AcquaintanceListSortInit extends AcquaintanceListState {
  final List<SortColumnDetails>? sortDataList;

  const AcquaintanceListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'AcquaintanceListSortInit { sortDataList: $sortDataList }';

}

class AcquaintanceListFailure extends AcquaintanceListState {
  final String? error;

  const AcquaintanceListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AcquaintanceListFailure { error: $error }';
}
