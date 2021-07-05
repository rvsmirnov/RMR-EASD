import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';
import 'package:printing/printing.dart';
import 'package:split_view/split_view.dart';

class Draw extends StatefulWidget {
  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = <DrawingPoints>[];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

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
                            icon: Icon(Icons.album),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.StrokeWidth)
                                  showBottomList = !showBottomList;
                                selectedMode = SelectedMode.StrokeWidth;
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.opacity),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.Opacity)
                                  showBottomList = !showBottomList;
                                selectedMode = SelectedMode.Opacity;
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.color_lens),
                            onPressed: () {
                              setState(() {
                                if (selectedMode == SelectedMode.Color)
                                  showBottomList = !showBottomList;
                                selectedMode = SelectedMode.Color;
                              });
                            }),
                        IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                showBottomList = false;
                                points.clear();
                              });
                            }),
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
                    Visibility(
                      child: (selectedMode == SelectedMode.Color)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: getColorList(),
                            )
                          : Slider(
                              value: (selectedMode == SelectedMode.StrokeWidth)
                                  ? strokeWidth
                                  : opacity,
                              max: (selectedMode == SelectedMode.StrokeWidth)
                                  ? 50.0
                                  : 1.0,
                              min: 0.0,
                              onChanged: (val) {
                                setState(() {
                                  if (selectedMode == SelectedMode.StrokeWidth)
                                    strokeWidth = val;
                                  else
                                    opacity = val;
                                });
                              }),
                      visible: showBottomList,
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
            ListView.builder(
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
                        // scale: 2 * leftSplitterWidth,
                        scale:
                            leftSplitterWidth < 0.5 ? 1 : 2 * leftSplitterWidth,
                        child: Container(
                            color: Colors.blue.withOpacity(0.5),
                            child: e['image']),
                      ),
                      Transform.scale(
                        alignment: Alignment.topLeft,
                        scale: 2 * leftSplitterWidth,
                        child: Container(
                          //   height: 384,
                          //  width: 586,
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                RenderBox renderBox =
                                    context.findRenderObject() as RenderBox;
                                points.add(DrawingPoints(
                                    points: renderBox
                                        .globalToLocal(details.globalPosition),
                                    paint: Paint()
                                      ..strokeCap = strokeCap
                                      ..isAntiAlias = true
                                      ..color =
                                          selectedColor.withOpacity(opacity)
                                      ..strokeWidth = strokeWidth));
                              });
                            },
                            onPanStart: (details) {
                              setState(() {
                                RenderBox renderBox =
                                    context.findRenderObject() as RenderBox;
                                points.add(DrawingPoints(
                                    points: renderBox
                                        .globalToLocal(details.globalPosition),
                                    paint: Paint()
                                      ..strokeCap = strokeCap
                                      ..isAntiAlias = true
                                      ..color =
                                          selectedColor.withOpacity(opacity)
                                      ..strokeWidth = strokeWidth));
                              });
                            },
                            onPanEnd: (details) {
                              setState(() {
                                points.add(DrawingPoints());
                              });
                            },
                            child: Container(
                              height: 400,
                              width: 400,
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: DrawingPainter(
                                  pointsList: points,
                                ),
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

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});
  List<DrawingPoints>? pointsList;
  List<Offset> offsetPoints = <Offset>[];
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList!.length - 1; i++) {
      if (pointsList![i] != null && pointsList![i + 1] != null) {
        canvas.drawLine(pointsList![i].points!, pointsList![i + 1].points!,
            pointsList![i].paint!);
      } else if (pointsList![i] != null && pointsList![i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList![i].points!);
        offsetPoints.add(Offset(
            pointsList![i].points!.dx + 0.1, pointsList![i].points!.dy + 0.1));
        canvas.drawPoints(
            PointMode.points, offsetPoints, pointsList![i].paint!);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint? paint;
  Offset? points;
  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
