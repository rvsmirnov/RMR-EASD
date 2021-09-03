part of 'rk_card_bloc.dart';

abstract class RKCardState extends Equatable {
  const RKCardState();

  @override
  List<Object?> get props => [];
}

class RKCardInitial extends RKCardState {}

class RKCardLoading extends RKCardState {}

class RKCardData extends RKCardState {
  final List<String>? numberVoiceList;
  final String? errorMessage;
  final bool? resetVoiceNumber;
  final Duration? duration;
  final bool? showRecordingDialog;

  const RKCardData({
    @required this.numberVoiceList,
    this.errorMessage = '',
    this.resetVoiceNumber = false,
    this.duration = const Duration(),
    this.showRecordingDialog = false,
  });

  @override
  List<Object?> get props => [numberVoiceList, errorMessage, resetVoiceNumber, duration, showRecordingDialog];

  @override
  String toString() =>
      'RKCardData { numberVoiceList: $numberVoiceList errorMessage: $errorMessage resetVoiceNumber: $resetVoiceNumber duration: $duration showRecordingDialog $showRecordingDialog }';
}

class RKCardFailure extends RKCardState {
  final String? error;

  const RKCardFailure({@required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'RKCardFailure { error: $error }';
}
