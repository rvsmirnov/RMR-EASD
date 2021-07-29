part of 'decision_card_bloc.dart';

abstract class DecisionCardState extends Equatable {
  const DecisionCardState();

  @override
  List<Object?> get props => [];
}

class DecisionCardInitial extends DecisionCardState {}

class DecisionCardLoading extends DecisionCardState {}

class DecisionCardDataReceived extends DecisionCardState {
  final List<Map>? foldersDecisionCardDataList;

  const DecisionCardDataReceived({@required this.foldersDecisionCardDataList});

  @override
  List<Object?> get props => [foldersDecisionCardDataList];

  @override
  String toString() => 'DecisionCardDataReceived { foldersDecisionCardDataList: $foldersDecisionCardDataList }';

}

class DecisionCardFailure extends DecisionCardState {
  final String? error;

  const DecisionCardFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'DecisionCardFailure { error: $error }';
}
