part of 'rk_card_bloc.dart';

abstract class RKCardEvent extends Equatable {
  const RKCardEvent();

  @override
  List<Object?> get props => [];
}

class OpenScreen extends RKCardEvent {}

class StartRecording extends RKCardEvent {}

class StopRecording extends RKCardEvent {}

class StartPlayer extends RKCardEvent {
  final String? voiceNumber;

  const StartPlayer({
    @required this.voiceNumber,
  });

  @override
  List<Object?> get props => [voiceNumber];

  @override
  String toString() => 'StartPlayer {voiceNumber: $voiceNumber }';
}

class StopPlayer extends RKCardEvent {}

class DeleteFile extends RKCardEvent {
  final String? voiceNumber;

  const DeleteFile({
    @required this.voiceNumber,
  });

  @override
  List<Object?> get props => [voiceNumber];

  @override
  String toString() => 'DeleteFile {voiceNumber: $voiceNumber }';
}

class CloseAudioSession extends RKCardEvent {}
