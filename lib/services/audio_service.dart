import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  final AudioSource theSource = AudioSource.microphone;

  FlutterSoundPlayer? _player = FlutterSoundPlayer(logLevel: Level.info);
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder(logLevel: Level.info);

  bool get playerIsStopped {
    return _player!.isStopped;
  }

  bool get recorderIsStopped {
    return _recorder!.isStopped;
  }

  bool get playerIsPlaying {
    return _player!.isPlaying;
  }

  bool get recorderIsRecording {
    return _recorder!.isRecording;
  }

  Future<bool?> initPlayer() async {
    await _player!.openAudioSession();
    return true;
  }

  Future<bool?> initRecorder() async {
    return await openTheRecorder();
  }

  Future<bool?> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException(
            'Нет разрешения на использование микрофона!');
      }
    }
    await _recorder!.openAudioSession();
    return true;
  }

  Future<bool?> record({String? path}) async {
    await _recorder!.startRecorder(
      codec: Codec.defaultCodec,
      toFile: path,
      audioSource: theSource,
    );
    return true;
  }

  Future<bool?> stopRecorder() async {
    String? path = await _recorder!.stopRecorder();
    print('--path in stopRecorder $path');
    return true;
  }

  Future<Duration?> play({String? path}) async {
    try {
      Duration? duration = await _player!.startPlayer(
        fromURI: path,
        codec: Codec.mp3,
        // whenFinished: () {
        //   setState(() {});
        // },
      );
      print('duration $duration');
      return duration!;
    } catch (e) {
      return null;
    }
  }

  Future<void> stopPlayer() async {
    await _player!.stopPlayer();
  }

  Future<void> closeAudioSession() async {
    await _player!.closeAudioSession();
    // _player = null;

    await _recorder!.closeAudioSession();
    // _recorder = null;
  }
}
