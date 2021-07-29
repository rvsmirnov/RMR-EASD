part of 'rk_card_bloc.dart';

abstract class RKCardEvent extends Equatable {
  const RKCardEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends RKCardEvent {}


