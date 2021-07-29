part of 'sign_list_bloc.dart';

abstract class SignListEvent extends Equatable {
  const SignListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends SignListEvent {}

class SortDataSave extends SignListEvent {
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


