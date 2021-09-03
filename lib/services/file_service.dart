import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileService {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get getTemporaryDirectoryPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  // Это временная директория на iOS
  Future<String> get getTmpDirectoryPathOnIos async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return "${directory.parent.path}/tmp/";
  }

  Future<String> get getTempDirectory async {
    String? tmpDirectory;
    if (Platform.isAndroid) {
      tmpDirectory = await getTemporaryDirectoryPath;
    } else if (Platform.isIOS) {
      tmpDirectory = await getTmpDirectoryPathOnIos;
    }
    return tmpDirectory!;
  }

  Future<File> getLocalFile(String path) async {
    return File(path);
  }

  Future<bool?> deleteFile(File file) async {
    try {
      await file.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future getFileFromAssetsToPath({String? assetsPath, String? fileName}) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, fileName);
    ByteData data = await rootBundle.load(assetsPath!);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return '${directory.path}/$fileName';
  }

  // final AudioSource theSource = AudioSource.microphone;

  // FlutterSoundPlayer? _player = FlutterSoundPlayer(logLevel: Level.info);
  // FlutterSoundRecorder? _recorder = FlutterSoundRecorder(logLevel: Level.info);

  // bool get playerIsStopped {
  //   return _player!.isStopped;
  // }

  // bool get recorderIsStopped {
  //   return _recorder!.isStopped;
  // }

  // bool get playerIsPlaying {
  //   return _player!.isPlaying;
  // }

  // bool get recorderIsRecording {
  //   return _recorder!.isRecording;
  // }

  // Future<bool?> initPlayer() async {
  //   await _player!.openAudioSession();
  //   return true;
  // }

  // Future<bool?> initRecorder() async {
  //   return await openTheRecorder();
  // }

  // Future<bool?> openTheRecorder() async {
  //   if (!kIsWeb) {
  //     var status = await Permission.microphone.request();
  //     if (status != PermissionStatus.granted) {
  //       throw RecordingPermissionException(
  //           'Нет разрешения на использование микрофона!');
  //     }
  //   }
  //   await _recorder!.openAudioSession();
  //   return true;
  // }

  // Future<bool?> record({String? path}) async {
  //   await _recorder!.startRecorder(
  //     toFile: path,
  //     audioSource: theSource,
  //   );
  //   return true;
  // }

  // Future<bool?> stopRecorder() async {
  //   await _recorder!.stopRecorder();
  //   return true;
  // }

  // Future<void> play({String? path}) async {
  //   await _player!.startPlayer(
  //     fromURI: path,
  //     //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
  //     // whenFinished: () {
  //     //   setState(() {});
  //     // },
  //   );
  // }

  // Future<void> stopPlayer() async {
  //   await _player!.stopPlayer();
  // }
}
