import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';
import 'package:printing/printing.dart';
import 'package:split_view/split_view.dart';

class Draw2 extends StatefulWidget {
  @override
  _Draw2State createState() => _Draw2State();
}

class _Draw2State extends State<Draw2> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;

  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];
  List<Offset> points = [];

  PainterController paintController = _newPaintController();
  int oldIndex = 0;
  List<Map> imageList = <Map>[];

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  static PainterController _newPaintController() {
    PainterController paintController = new PainterController();
    paintController.thickness = 5.0;
    paintController.backgroundColor = Colors.transparent;
    return paintController;
  }

  double leftSplitterWidth = 0.5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.greenAccent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            onPressed: () async {
                              List<Map> list = <Map>[];

                              ByteData bd =
                                  await rootBundle.load('assets/files/232.pdf');

                              await for (var page in Printing.raster(
                                  bd.buffer.asUint8List(),
                                  dpi: 72)) {
                                final page1 = await page.toPng();

                                Image image = Image.memory(page1);
                                PainterController controller = _newController();
                                Map imageAndController = {
                                  'image': image,
                                  'controller': controller,
                                };
                                list.add(imageAndController);
                                // list.add(SizedBox(height: 20,),);

                                print('0 list count ${list.length}');
                              }
                              print('2 list count ${list.length}');
                              setState(() {
                                imageList = list;
                              });
                            },
                            icon: Icon(Icons.assignment)),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        body: SplitView(
          gripColor: Colors.white,
          controller: SplitViewController(limits: [
            // WeightLimit(min: 0.02),
            // WeightLimit(min: 0.02),
          ]),
          onWeightChanged: (w) => setState(() {
            leftSplitterWidth = w[0]!.toDouble();
            print('leftSplitterWidth $leftSplitterWidth');
          }),
          viewMode: SplitViewMode.Horizontal,
          activeIndicator: SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
            isActive: true,
          ),
          children: [
            Container(
              height: 800,
              width: 400,
              child: ListView.builder(
                itemCount: imageList.length,
                itemBuilder: (context1, int index) {
                  // из имеджКонтроллера используем только запись линий и присваиваем это каждый раз при переходе
                  // но как быть с отображением линий на других картинках?
                  // контроллер текущей картинки
                  paintController = imageList[index]['controller'];

                  print('image index $index');
                  // if (index == oldIndex) {

                  // }
                  if (imageList.length < 1) {
                    return SizedBox();
                  }
                  return imageList.map((e) {
                    return Stack(
                      children: [
                        Transform.scale(
                          alignment: Alignment.topLeft,
                          scale: 2 * leftSplitterWidth,
                          // scale: leftSplitterWidth < 0.4
                          //     ? 1
                          //     : 2 * leftSplitterWidth,
                          child: Container(
                              color: Colors.blue.withOpacity(0.5),
                              child: e['image']),
                        ),
                        Transform.scale(
                          alignment: Alignment.topLeft,
                          scale: 2 * leftSplitterWidth,
                          child: GestureDetector(
                            onPanDown: (details) {
                              print('-- onPanDown');
                              this.setState(() {
                                points.add(details.localPosition);
                              });
                            },
                            onPanUpdate: (details) {
                              print('-- onPanUpdate');

                              this.setState(() {
                                points.add(details.localPosition);
                              });
                            },
                            onPanEnd: (details) {
                              print('-- onPanEnd');

                              this.setState(() {
                                // points.add(null);
                              });
                            },
                            child: Container(
                              // эти размеры нужно получить
                              height: 586,
                              width: 384,
                              color: Colors.green.withOpacity(0.3),
                              child: ClipRRect(
                                child: CustomPaint(
                                  painter: CanvasCustomPainter(points: points),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList()[index];
                },
              ),
            ),
            Container(),
          ],
        ));
  }

  getColorList() {
    List<Widget> listWidget = <Widget>[];
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Pick a color!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (color) {
                      pickerColor = color;
                    },
                    // enableLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      setState(() => selectedColor = pickerColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class CanvasCustomPainter extends CustomPainter {
  List<Offset>? points;

  CanvasCustomPainter({@required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    //define canvas background color
    Paint background = Paint()..color = Colors.transparent;

    //define canvas size
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    //define the paint properties to be used for drawing
    Paint drawingPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..color = Colors.black
      ..strokeWidth = 1.5;

    //a single line is defined as a series of points followed by a null at the end
    for (int x = 0; x < points!.length - 1; x++) {
      //drawing line between the points to form a continuous line
      if (points![x] != null && points![x + 1] != null) {
        canvas.drawLine(points![x], points![x + 1], drawingPaint);
      }
      //if next point is null, means the line ends here
      else if (points![x] != null && points![x + 1] == null) {
        canvas.drawPoints(PointMode.points, [points![x]], drawingPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasCustomPainter oldDelegate) {
    return true;
  }
}
