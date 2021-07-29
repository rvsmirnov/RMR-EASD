part of 'agreement_card_bloc.dart';

abstract class AgreementCardEvent extends Equatable {
  const AgreementCardEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends AgreementCardEvent {}


