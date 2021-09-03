import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:MWPX/services/file_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:open_file/open_file.dart';

class OpenFileWidget extends StatefulWidget {
  @override
  _OpenFileWidgetState createState() => _OpenFileWidgetState();
}

class _OpenFileWidgetState extends State<OpenFileWidget> {
  var _openResult = 'Unknown';

  Future<void> openFile() async {
    String? filePath = await FileService.getFileFromAssetsToPath(assetsPath: 'assets/files/doc1.doc', fileName:'doc1.doc',);
    // String? filePath = 'assets/files/doc1.doc';
    // String? filePath = 'assets/files/3.pdf';
    // FilePickerResult? result = await FilePicker.platform.pickFiles();

    // if (result != null) {
    //   filePath = result.files.single.path;
    // } else {
    //   // User canceled the picker
    // }
    final OpenResult _result = await OpenFile.open(filePath);
    print(_result.message);


    setState(() {
      _openResult = "type=${_result.type}  message=${_result.message}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('open result: $_openResult\n'),
              TextButton(
                child: Text('Tap to open file'),
                onPressed: openFile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}