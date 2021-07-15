part of 'control_list_bloc.dart';

abstract class ControlListEvent extends Equatable {
  const ControlListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends ControlListEvent {}

class SortDataSave extends ControlListEvent {
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


