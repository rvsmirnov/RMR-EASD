import 'package:MWPX/widgets/button/squarebutton.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/constants.dart' as Constants;

// для второго виджета
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';

/// Страница с плитками папок
class GraphicNotesScreen extends StatefulWidget {
  final void Function(String)? onPressed;
  final String? textFieldContent;

  GraphicNotesScreen({this.onPressed, this.textFieldContent});

  @override
  State<GraphicNotesScreen> createState() => _GraphicNotesScreenState();
}

class _GraphicNotesScreenState extends State<GraphicNotesScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.textFieldContent!;
  }

  Widget build(BuildContext context) {
    print('onPressed in GraphicNotesScreen ${widget.onPressed}');
    MWPMainAppBar app_bar = MWPMainAppBar();
    MWPButtonBar button_bar = MWPButtonBar();

    app_bar.configureAppBar('Резолюция', false, true);
    button_bar.configureButtonBar(Constants.viewNameFolders);

    return Scaffold(
      appBar: app_bar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
            ),
          ),
          Align(
            child: Container(
                alignment: Alignment.center,
                height: 75,
                width: double.infinity,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MWPSquareButton(
                      'Сохранить',
                      onPressed: () {
                        widget.onPressed!(controller.text);
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class GraphicNotesScreen2 extends StatefulWidget {
  @override
  _GraphicNotesScreen2State createState() => _GraphicNotesScreen2State();
}

class _GraphicNotesScreen2State extends State<GraphicNotesScreen2> {
  ui.Image? image;
  bool isImageloaded = false;
  GlobalKey _myCanvasKey = new GlobalKey();

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/1.png');
    image = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget? _buildImage() {
    ImageEditor editor = ImageEditor(image: image);
    MWPMainAppBar app_bar = MWPMainAppBar();
    MWPButtonBar button_bar = MWPButtonBar();

    app_bar.configureAppBar('Пример работы с изображениями', false, true);
    button_bar.configureButtonBar(Constants.viewNameFolders);

    return Scaffold(
        appBar: app_bar,
        body: this.isImageloaded
            ? Container(
                width: 400,
                height: 400,
                child: GestureDetector(
                  onPanDown: (detailData) {
                    editor.update(detailData.localPosition);
                    _myCanvasKey.currentContext!
                        .findRenderObject()!
                        .markNeedsPaint();
                  },
                  onPanUpdate: (detailData) {
                    editor.update(detailData.localPosition);
                    _myCanvasKey.currentContext!
                        .findRenderObject()!
                        .markNeedsPaint();
                  },
                  child: CustomPaint(
                    key: _myCanvasKey,
                    painter: editor,
                  ),
                ),
              )
            : Center(child: Text('loading')));
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage()!;
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor({
    this.image,
  });

  ui.Image? image;

  List<Offset> points = <Offset>[];

  final Paint painter = new Paint()
    ..color = Colors.blue[400]!
    ..style = PaintingStyle.fill;

  void update(Offset offset) {
    points.add(offset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image!, Offset(0.0, 0.0), Paint());
    for (Offset offset in points) {
      canvas.drawCircle(offset, 10, painter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
