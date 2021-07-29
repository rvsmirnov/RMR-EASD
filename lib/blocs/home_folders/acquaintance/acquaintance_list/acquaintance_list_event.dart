part of 'acquaintance_list_bloc.dart';

abstract class AcquaintanceListEvent extends Equatable {
  const AcquaintanceListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends AcquaintanceListEvent {}

class SortDataSave extends AcquaintanceListEvent {
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


