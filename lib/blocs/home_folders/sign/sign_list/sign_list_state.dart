part of 'sign_list_bloc.dart';

abstract class SignListState extends Equatable {
  const SignListState();

  @override
  List<Object?> get props => [];
}

class SignListInitial extends SignListState {}

class SignListLoading extends SignListState {}

class SignListSortInit extends SignListState {
  final List<SortColumnDetails>? sortDataList;

  const SignListSortInit({@required this.sortDataList});

  @override
  List<Object?> get props => [sortDataList];

  @override
  String toString() => 'SignListSortInit { sortDataList: $sortDataList }';

}

class SignListFailure extends SignListState {
  final String? error;

  const SignListFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'SignListFailure { error: $error }';
}
