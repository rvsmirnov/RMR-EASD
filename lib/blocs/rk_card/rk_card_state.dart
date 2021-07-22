part of 'rk_card_bloc.dart';

abstract class RKCardState extends Equatable {
  const RKCardState();

  @override
  List<Object?> get props => [];
}

class RKCardInitial extends RKCardState {}

class RKCardLoading extends RKCardState {}

class RKCardDataReceived extends RKCardState {
  final List<Map>? foldersRKCardDataList;

  const RKCardDataReceived({@required this.foldersRKCardDataList});

  @override
  List<Object?> get props => [foldersRKCardDataList];

  @override
  String toString() => 'RKCardDataReceived { foldersRKCardDataList: $foldersRKCardDataList }';

}

class RKCardFailure extends RKCardState {
  final String? error;

  const RKCardFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'RKCardFailure { error: $error }';
}
