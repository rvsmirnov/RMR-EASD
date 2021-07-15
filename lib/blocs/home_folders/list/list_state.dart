part of 'list_bloc.dart';

abstract class AgreementListState extends Equatable {
  const AgreementListState();

  @override
  List<Object?> get props => [];
}

class AgreementListInitial extends AgreementListState {}

class AgreementListLoading extends AgreementListState {}

class AgreementListSortInit extends AgreementListState {
  final List<SortColumnDetails>? sortDataList;

  const AgreementListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'AgreementListSortInit { sortDataList: $sortDataList }';

}

class AgreementListFailure extends AgreementListState {
  final String? error;

  const AgreementListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AgreementListFailure { error: $error }';
}
