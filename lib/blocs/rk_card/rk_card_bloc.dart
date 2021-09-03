import 'dart:io';

import 'package:MWPX/services/audio_service.dart';
import 'package:MWPX/services/file_service.dart';
import 'package:MWPX/services/report_service.dart';
// import 'package:MWPX/styles/mwp_icons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:meta/meta.dart';

part 'rk_card_event.dart';
part 'rk_card_state.dart';

class RKCardBloc extends Bloc<RKCardEvent, RKCardState> {
  final ReportService? reportService;
  final AudioService? audioService;
  final FileService? fileService;

  RKCardBloc({
    @required this.reportService,
    @required this.audioService,
    @required this.fileService,
  })  : assert(
          reportService != null,
          audioService != null,
          // fileService != null,
        ),
        super(RKCardInitial());

  bool? playerIsInited = false;
  bool? recorderIsInited = false;
  bool? playbackReady = false;
  String path = 'flutter_sound_example';
  int voiceNumber = 1;
  List<String> numberVoiceList = <String>[];

  @override
  Stream<RKCardState> mapEventToState(RKCardEvent event) async* {
    if (event is OpenScreen) {
      try {
        yield RKCardLoading();
        playerIsInited = await audioService!.initPlayer();
        recorderIsInited = await audioService!.initRecorder();
        yield RKCardData(
          numberVoiceList: numberVoiceList,
        );
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
    if (event is StartRecording) {
      try {
        yield RKCardLoading();
        print('--StartRecording--');
        if (recorderIsInited == true && audioService!.recorderIsStopped) {
          await audioService!.record(path: '$path$voiceNumber.aac');
        }
        yield RKCardData(
          numberVoiceList: numberVoiceList,
        );
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
    if (event is StopRecording) {
      try {
        yield RKCardLoading();
        print('--StopRecording--');
        if (recorderIsInited == true && !audioService!.recorderIsStopped) {
          await audioService!.stopRecorder();
          numberVoiceList.add(voiceNumber.toString());
          voiceNumber++;
          playbackReady = true;
        }
        print('--StopRecording-- numberVoiceList $numberVoiceList');
        yield RKCardData(
          numberVoiceList: numberVoiceList,
        );
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
    if (event is StartPlayer) {
      try {
        yield RKCardLoading();
        print('--StartRecording--');
        if (playerIsInited == true &&
            audioService!.playerIsStopped &&
            playbackReady == true) {
          if (playerIsInited == true &&
              playbackReady == true &&
              audioService!.recorderIsStopped &&
              audioService!.playerIsStopped) {
            String? tmpDirectory = await fileService!.getTempDirectory;
            String pathAAC = '$path${event.voiceNumber}.aac';
            String pathMP3 = '$path${event.voiceNumber}.mp3';
            // Тут происходит конвертация AAC в MP3
            await FlutterSoundHelper().convertFile('$tmpDirectory/$pathAAC',
                Codec.aacADTS, '$tmpDirectory/$pathMP3', Codec.mp3);
            Duration? duration = await audioService!.play(path: pathMP3);
            print('duration in StartPlayer event: $duration');
            if (duration == null) {
              yield RKCardData(
                errorMessage: 'Выберите голосовую резолюцию для прослушивания.',
                numberVoiceList: numberVoiceList,
              );
            } else {
              yield RKCardData(
                numberVoiceList: numberVoiceList,
                duration: duration,
                showRecordingDialog: true,
              );
            }
          }
        }
        yield RKCardData(
          numberVoiceList: numberVoiceList,
        );
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
    if (event is StopPlayer) {
      try {
        yield RKCardLoading();
        print('--StopRecording--');
        if (playerIsInited == true && !audioService!.playerIsStopped) {
          await audioService!.stopPlayer();
        }
        yield RKCardData(
          numberVoiceList: numberVoiceList,
        );
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
    // DeleteFile
    if (event is DeleteFile) {
      try {
        yield RKCardLoading();
        print('--DeleteFile--');
        if (audioService!.recorderIsStopped && audioService!.playerIsStopped) {
          // String temporaryDirectoryPath = await fileService!.getTemporaryDirectoryPath;
          // String localPath = await fileService!.localPath;
          String? tmpDirectory = await fileService!.getTempDirectory;
          File fileAAC = await fileService!
              .getLocalFile('$tmpDirectory/$path${event.voiceNumber}.aac');
          File fileMP3 = await fileService!
              .getLocalFile('$tmpDirectory/$path${event.voiceNumber}.mp3');
          bool? isDeleteAAC = await fileService!.deleteFile(fileAAC);
          bool? isDeleteMP3 = await fileService!.deleteFile(fileMP3);
          print('-- isDeleteAAC $isDeleteAAC');
          print('-- isDeleteMP3 $isDeleteMP3');

          if (isDeleteAAC == true && isDeleteMP3 == true) {
            numberVoiceList.remove(event.voiceNumber);
            yield RKCardData(
              resetVoiceNumber: true,
              numberVoiceList: numberVoiceList,
            );
          } else {
            yield RKCardData(
              errorMessage: 'Выберите голосовую заметку для удаления.',
              numberVoiceList: numberVoiceList,
            );
          }
        } else {
          yield RKCardData(
            numberVoiceList: numberVoiceList,
          );
        }
      } catch (error) {
        print('error in RKCardBloc $error');
        yield RKCardFailure(error: error.toString());
      }
    }
    if (event is CloseAudioSession) {
      print('-- CloseAudioSession');
      await audioService!.closeAudioSession();
    }
  }
}
