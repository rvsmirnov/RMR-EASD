part of 'agreement_list_bloc.dart';

abstract class AgreementListEvent extends Equatable {
  const AgreementListEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends AgreementListEvent {}

class SortDataSave extends AgreementListEvent {
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


