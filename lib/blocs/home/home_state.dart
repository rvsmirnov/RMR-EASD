part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeDataReceived extends HomeState {
  final List<Map>? foldersHomeDataList;

  const HomeDataReceived({@required this.foldersHomeDataList});

  @override
  List<Object?> get props => [foldersHomeDataList];

  @override
  String toString() => 'HomeDataReceived { foldersHomeDataList: $foldersHomeDataList }';

}

class HomeFailure extends HomeState {
  final String? error;

  const HomeFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'HomeFailure { error: $error }';
}
