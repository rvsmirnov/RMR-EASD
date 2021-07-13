part of 'decision_card_bloc.dart';

abstract class DecisionCardEvent extends Equatable {
  const DecisionCardEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends DecisionCardEvent {}


