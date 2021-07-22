part of 'agreement_card_bloc.dart';

abstract class AgreementCardState extends Equatable {
  const AgreementCardState();

  @override
  List<Object?> get props => [];
}

class AgreementCardInitial extends AgreementCardState {}

class AgreementCardLoading extends AgreementCardState {}

class AgreementCardDataReceived extends AgreementCardState {
  final List<Map>? foldersAgreementCardDataList;

  const AgreementCardDataReceived({@required this.foldersAgreementCardDataList});

  @override
  List<Object?> get props => [foldersAgreementCardDataList];

  @override
  String toString() => 'AgreementCardDataReceived { foldersAgreementCardDataList: $foldersAgreementCardDataList }';

}

class AgreementCardFailure extends AgreementCardState {
  final String? error;

  const AgreementCardFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'AgreementCardFailure { error: $error }';
}
