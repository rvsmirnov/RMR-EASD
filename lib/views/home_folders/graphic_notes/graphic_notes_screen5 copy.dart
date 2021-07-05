import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:open_file/open_file.dart';
import 'package:painter/painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdfRender;
import 'package:printing/printing.dart';
import 'package:split_view/split_view.dart';

class MyHomePage5 extends StatefulWidget {
  MyHomePage5({this.title});

  final String? title;

  @override
  _MyHomePage5State createState() => _MyHomePage5State();
}

class _MyHomePage5State extends State<MyHomePage5> {
  bool _finished = false;
  PainterController _controller = _newController();
  PainterController paintController = _newPaintController();
  int oldIndex = 0;

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

  // метод для сохранения нарисованного
  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('View your image'),
        ),
        body: new Container(
            alignment: Alignment.center,
            child: new FutureBuilder<Uint8List>(
              future: picture.toPNG(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return Image.memory(snapshot.data!);
                    }
                  default:
                    return new Container(
                        child: new FractionallySizedBox(
                      widthFactor: 0.1,
                      child: new AspectRatio(
                          aspectRatio: 1.0,
                          child: new CircularProgressIndicator()),
                      alignment: Alignment.center,
                    ));
                }
              },
            )),
      );
    }));
  }

  void _edit() async {
    PdfMutableDocument doc =
        await PdfMutableDocument.asset("assets/files/3.pdf");
    _editDocument(doc);
    File file = await doc.save(filename: "modified.pdf");
    final dir = (await getApplicationDocumentsDirectory()).path;
    print("PDF Edition Done");
    await OpenFile.open('$dir${Platform.pathSeparator}modified.pdf');
    // await OpenFile.open(filePath)
  }

  void _open() async {
    pdfAsset().then((file) {
      OpenFile.open(file.path);
    });
  }

  // метод для переноса начального файла во временный фаил, так как иначе опенфаил его не открывает
  Future<File> pdfAsset() async {
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/set_any_name.pdf');
    ByteData bd = await rootBundle.load('assets/files/3.pdf');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;

    // Canvas().
  }

  void _editDocument(PdfMutableDocument document) {
    // var page = document.getPage(0);
    document._pages.forEach((element) {
      element.add(
        item: pdfWidgets.Positioned(
          left: 0.0,
          top: 0.0,
          child: pdfWidgets.Text(
            "COUCOU",
            style: pdfWidgets.TextStyle(fontSize: 32, color: pdf.PdfColors.red),
          ),
        ),
      );
      var centeredText = pdfWidgets.Center(
        child: pdfWidgets.Text(
          "CENTERED TEXT",
          style: pdfWidgets.TextStyle(
            fontSize: 40,
            color: pdf.PdfColors.green,
            background: pdfWidgets.BoxDecoration(color: pdf.PdfColors.amber),
          ),
        ),
      );
      element.add(item: centeredText);
    });
  }

  List<Map> imageList = <Map>[];
  // ListWheelChildDelegate listWheelChildDelegate = <Widget>[];
  // List<Widget> imageListInContainer = <Widget>[];
  double leftSplitterWidth = 0.5;

  double? imageHeight;
  double? imageWidth;

  @override
  Widget build(BuildContext context) {
    // Canvas canvas = Canvas(PictureRecorder());
    // canvas.drawImage(image, offset, paint)

    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        new IconButton(
          icon: new Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        new IconButton(
            icon: new Icon(
              Icons.undo,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        new Text('Nothing to undo'));
              } else {
                _controller.undo();
                paintController.undo();
              }
            }),
        new IconButton(
            icon: new Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
        new IconButton(
            icon: new Icon(Icons.check),
            // тут в метод шоу передается изображение из _controller.finish()
            onPressed: () => _show(_controller.finish(), context)),
      ];
    }

    // List<PdfMutablePage> listPdfMutablePage = <PdfMutablePage>[];
    print('-- imageList lenght ${imageList.length}');

    // double getContainerWidth(double leftSplitterWidth) {
    //   return 400*leftSplitterWidth;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        actions: [
          ...actions,
          IconButton(
              onPressed: () async {
                List<Map> list = <Map>[];

                ByteData bd = await rootBundle.load('assets/files/232.pdf');

                await for (var page
                    in Printing.raster(bd.buffer.asUint8List(), dpi: 72)) {
                  final page1 = await page.toPng();
                  // int elementSizeInBytes = page1.elementSizeInBytes;

                  // print('- elementSizeInBytes $elementSizeInBytes');
                  Image image = Image.memory(page1);
                  var decodedImage = await decodeImageFromList(page1);
                  int imgWidth = decodedImage.width;
                  int imgHeight = decodedImage.height;
                  print('-- imgWidth $imgWidth imgHeight $imgHeight');
                  setState(() {
                    imageHeight = double.parse(imgHeight.toString());
                    imageWidth = double.parse(imgWidth.toString());
                  });
                  // double? imageHeight = image.height;
                  // double? imageWidth = image.width;
                  // print('-- imageHeight $imageHeight');
                  // print('-- imageWidth $imageWidth');
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

                  //   imageListInContainer = imageList.map(
                  //   (e) => Container(
                  //     padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //     margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //     // decoration:
                  //     //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                  //     color: Colors.red,
                  //     child: e,
                  //   ),
                  // );
                });
              },
              icon: Icon(Icons.assignment))
        ],
        bottom: new PreferredSize(
          child: new DrawBar(_controller, paintController),
          preferredSize: new Size(MediaQuery.of(context).size.width, 30.0),
        ),
      ),
      // body: Container(child: File('assets/files/3.pdf'),),
      // body: Container(child: Column(children: [...listPdfMutablePage.map((e) => pdfWidgets.Image(e._background))])),
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
          // ListView(
          //   children: [
          //     ...imageList.map((e) {
          //       PainterController controller = _newController();
          //       return Stack(
          //         children: [
          //           Container(
          //             height: 400,
          //             width: 400,
          //             padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          //             margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          //             // decoration:
          //             //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          //             color: Colors.red,
          //             child: e,
          //           ),
          //           Container(
          //             height: 400,
          //             width: 400,
          //             child: new Painter(controller),
          //           ),
          //         ],
          //       );
          //     }).toList(),
          //   ],
          // ),
          // Container(
          //   constraints: BoxConstraints(
          //     // minHeight: 50,
          //     // minWidth: MediaQuery.of(context).size.width/2.2,
          //     minWidth: 400,
          //     // maxHeight: 80,
          //     // maxWidth: 80,
          //   ), //BoxConstraints
          //   child:
          // SingleChildScrollView(
          //   child: Column(children: [
          //     ...imageList.map((e) {
          //       return

          //           //   Container(
          //           // height:
          //           //     MediaQuery.of(context).size.height / leftSplitterWidth,
          //           // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          //           // decoration: BoxDecoration(
          //           //   border: Border.all(
          //           //     color: Colors.grey,
          //           //   ),
          //           //   // borderRadius: BorderRadius.circular(10.0),
          //           // ),
          //           // constraints: BoxConstraints(
          //           //   // minHeight: 50,
          //           //   // minWidth: MediaQuery.of(context).size.width/2.2,
          //           //   minWidth: 400,
          //           //   // maxHeight: 80,
          //           //   // maxWidth: 80,
          //           // ), //BoxConstraints
          //           //   IntrinsicHeight(
          //           // child:
          //           //
          //     //       Transform.scale(
          //     //     alignment: Alignment.topLeft,
          //     //     scale: 2 * leftSplitterWidth,
          //     //     child: Container(
          //     //       height: 600,
          //     //       width: 400,
          //     //       decoration: new BoxDecoration(
          //     //         image: new DecorationImage(
          //     //           image: new ExactAssetImage('assets/images/1.png'),
          //     //           // fit: BoxFit.cover,
          //     //         ),
          //     //       ),
          //     //       child: Painter(_controller),
          //     //     ),
          //     //   );
          //     // }).toList()
          //   ]),
          // ),
          ListView.builder(
            itemCount: imageList.length,
            itemBuilder: (context, int index) {
              // из имеджКонтроллера используем только запись линий и присваиваем это каждый раз при переходе
              // но как быть с отображением линий на других картинках?
              // контроллер текущей картинки
              paintController = imageList[index]['controller'];
              // Добавляем в наш текущий контроллер настройки из общего контроллера
              paintController.thickness = _controller.thickness;
              paintController.drawColor = _controller.drawColor;
              paintController.eraseMode = _controller.eraseMode;
              paintController.backgroundColor = _controller.backgroundColor;
              // paintController.thickness =
              // _controller.thickness = 4.0;
              // _controller.drawColor
              // _controller.eraseMode
              // _controller.backgroundColor
              print('image index $index');
              // if (index == oldIndex) {

              // }
              if (imageList.length < 1) {
                return SizedBox();
              }
              return imageList.map((e) {
                return

                    //   Container(
                    // height:
                    //     MediaQuery.of(context).size.height / leftSplitterWidth,
                    // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: Colors.grey,
                    //   ),
                    //   // borderRadius: BorderRadius.circular(10.0),
                    // ),
                    // constraints: BoxConstraints(
                    //   // minHeight: 50,
                    //   // minWidth: MediaQuery.of(context).size.width/2.2,
                    //   minWidth: 400,
                    //   // maxHeight: 80,
                    //   // maxWidth: 80,
                    // ), //BoxConstraints
                    //   IntrinsicHeight(
                    // child:
                    Stack(
                  children: [
                    // Container(
                    //   // height: MediaQuery.of(context).size.height *
                    //   //     leftSplitterWidth,
                    //   // width: MediaQuery.of(context).size.height *
                    //   //     leftSplitterWidth,
                    //   // constraints: BoxConstraints(
                    //   //   minWidth: MediaQuery.of(context).size.width / 2.2,
                    //   // ),
                    //   color: Colors.red,
                    //   child:
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Transform.scale(
                        alignment: Alignment.topLeft,
                        scale: 2 * leftSplitterWidth,
                        // scale:
                        //     leftSplitterWidth < 0.5 ? 1 : 2 * leftSplitterWidth,
                        child: Container(
                            // height: 586,
                            // width: 394,
                            //   constraints: BoxConstraints(
                            //   //  minWidth: MediaQuery.of(context).size.width / 2.2,
                            //    minWidth: 390,
                            //  ),

                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     color: Colors.grey,
                            //   ),
                            //   // borderRadius: BorderRadius.circular(10.0),
                            // ),
                            color: Colors.blue.withOpacity(0.5),
                            // height: MediaQuery.of(context).size.height *
                            //     leftSplitterWidth,
                            // width: MediaQuery.of(context).size.width *
                            //     leftSplitterWidth,
                            // width: 400,
                            child: e['image']
                            //     LayoutBuilder(builder: (context, constraints) {
                            //   debugPrint(
                            //       'Max height: ${constraints.maxHeight}, max width: ${constraints.maxWidth}');
                            //   return
                            //   e[
                            //       'image']; // create function here to adapt to the parent widget's constraints
                            // }),
                            ),
                      ),
                    ),
                    // ),
                    // leftSplitterWidth < 0.6
                    //     ? SizedBox()
                    //     :
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Transform.scale(
                        alignment: Alignment.topLeft,
                        scale: 2 * leftSplitterWidth,
                        // scale: 0.2,
                        // scale:
                        //     leftSplitterWidth < 0.5 ? 1 : 2 * leftSplitterWidth,
                        child: Container(
                          color: Colors.green.withOpacity(0.5),
                          // height: 384,
                          // width: 586,
                          // height: imageWidth,
                          // width: imageHeight,
                          height: 586,
                          width: 394,
                          // height: MediaQuery.of(context).size.height *
                          //     leftSplitterWidth,
                          // width: MediaQuery.of(context).size.width *
                          //     leftSplitterWidth,
                          // width: 400,
                          child: new Painter(
                            paintController,
                          ),
                        ),
                      ),
                    ),
                    // Transform.scale(
                    //   alignment: Alignment.topLeft,
                    //   scale: 2 * leftSplitterWidth,
                    //   child: Container(
                    //     //   height: 384,
                    //     //  width: 586,
                    //     child: CustomPaint(
                    //       painter: MyPainter2(20, Colors.brown[900]),
                    //       size: Size(50, 100),
                    //     ),
                    //   ),
                    // ),
                  ],
                  // ),
                  // ),
                  // ),
                );
              }).toList()[index];
            },
            // ),
          ),
          Container(),
        ],
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton.extended(
            heroTag: '1',
            onPressed: _edit,
            tooltip: 'Load',
            icon: Icon(Icons.file_download),
            label: Text("Modify"),
          ),
          FloatingActionButton.extended(
            heroTag: '2',
            onPressed: _open,
            tooltip: 'Open',
            icon: Icon(Icons.file_download),
            label: Text("Open"),
          ),
        ],
      ),
    );
  }
}

class PdfRawImage extends pdfWidgets.ImageProvider {
  final Uint8List? data;
  final Size? size;
  pdf.PdfDocument? document;

  PdfRawImage({this.data, this.size})
      : super(size!.width.toInt(), size.height.toInt(),
            pdf.PdfImageOrientation.topLeft, 72.0);

  @override
  pdf.PdfImage buildImage(pdfWidgets.Context context,
      {int? width, int? height}) {
    return pdf.PdfImage.file(
      document!,
      bytes: data!,
      orientation: orientation,
    );
  }
}

class _PdfFileHandler {
  // метод чтения PDF-файлов, упакованных в приложение.
  static Future<File> getFileFromAssets(String filename) async {
    assert(filename != null);
    final byteData = await rootBundle.load(filename);
    var name = filename.split(Platform.pathSeparator).last;
    var absoluteName = '${(await getLibraryDirectory()).path}/$name';
    final file = File(absoluteName);

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

  // получения данных страниц одну за другой.
  // Для каждой страницы мы визуализируем изображение с точным размером страницы,
  // а затем сохраняем данные (необработанное изображение и размер) в экземпляре PdfRawImage.
  static Future<List<PdfRawImage>> loadPdf(String path) async {
    var file = pdfRender.PdfImageRendererPdf(path: path);
    await file.open();
    var count = await file.getPageCount();
    var images = <PdfRawImage>[];
    for (var i = 0; i < count; i++) {
      var size = await file.getPageSize(pageIndex: 0);
      var rawImage = await file.renderPage(
        background: Colors.transparent,
        x: 0,
        y: 0,
        width: size.width,
        height: size.height,
        scale: 1.0,
        pageIndex: i,
      );
      images.add(PdfRawImage(
        data: rawImage,
        size: Size(size.width.toDouble(), size.height.toDouble()),
      ));
    }
    return images;
  }

  // Сохранить документ
  static Future<File> save(pdfWidgets.Document document, String filename,
      {String? directory}) async {
    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir${Platform.pathSeparator}$filename');
    return file.writeAsBytes(await document.save());
  }
}

// оболочки для pdfWidgets.Document и pdfWidgets.Page,
// которые будут содержать фоновые изображения и размер страницы
class PdfMutablePage {
  final PdfRawImage? _background;
  final List<pdfWidgets.Widget> _stackedItems;

  PdfMutablePage({PdfRawImage? background})
      : _background = background,
        _stackedItems = [];

  void add({pdfWidgets.Widget? item}) {
    _stackedItems.add(item!);
  }

  Size get size => _background!.size!;

  // создание документа pdf
  // мы определяем pdfWidgets.Page того же размера, что и полученное изображение,
  // названное в этом примере «_background».
  pdfWidgets.Page build(pdfWidgets.Document document) {
    _background!.document = document.document;
    final format =
        pdf.PdfPageFormat(_background!.size!.width, _background!.size!.height);
    return pdfWidgets.Page(
        pageFormat: format,
        orientation: pdfWidgets.PageOrientation.portrait,
        build: (context) {
          return pdfWidgets.Stack(
            children: [
              pdfWidgets.Image(_background!),
              ..._stackedItems,
            ],
          );
        });
  }
}

class PdfImageProvider extends ImageProvider {
  @override
  ImageStreamCompleter load(
      Object key,
      Future<ui.Codec> Function(Uint8List bytes,
              {bool allowUpscaling, int cacheHeight, int cacheWidth})
          decode) {
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    // TODO: implement obtainKey
    throw UnimplementedError();
  }
}

class PdfMutableDocument {
  String _filePath;
  final List<PdfMutablePage> _pages;

  PdfMutableDocument._({List<PdfMutablePage>? pages, String? filePath})
      : _pages = pages ?? [],
        _filePath = filePath!;

  // возвращает pdf документ в виде картинок
  static Future<PdfMutableDocument> asset(String assetName) async {
    var copy = await _PdfFileHandler.getFileFromAssets(assetName);
    final rawImages = await _PdfFileHandler.loadPdf(copy.path);
    final pages =
        rawImages.map((raw) => PdfMutablePage(background: raw)).toList();
    return PdfMutableDocument._(
        pages: pages, filePath: copy.uri.pathSegments.last);
  }

  void addPage(PdfMutablePage page) => _pages.add(page);

  PdfMutablePage getPage(int index) => _pages[index];

  pdfWidgets.Document build() {
    var doc = pdfWidgets.Document();
    _pages.forEach((page) => doc.addPage(page.build(doc)));
    return doc;
  }

  Future<File> save({String? filename}) async {
    return await _PdfFileHandler.save(build(), filename ?? _filePath);
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;
  final PainterController paintController;

  DrawBar(this._controller, this.paintController);

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Flexible(child: new StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return new Container(
              child: new Slider(
            value: _controller.thickness,
            onChanged: (double value) => setState(() {
              _controller.thickness = value;
              paintController.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        })),
        new StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return new RotatedBox(
              quarterTurns: _controller.eraseMode ? 2 : 0,
              child: IconButton(
                  icon: new Icon(Icons.create),
                  tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
                      ' eraser',
                  onPressed: () {
                    setState(() {
                      _controller.eraseMode = !_controller.eraseMode;
                      paintController.eraseMode = !paintController.eraseMode;
                    });
                  }));
        }),
        new ColorPickerButton(_controller, false),
        new ColorPickerButton(_controller, true),
        OutlinedButton(
          child: Container(
            color: Colors.red,
            width: 20,
            height: 20,
          ),
          onPressed: () {
            _controller.thickness = 4.0;
            _controller.drawColor = Colors.red;
            paintController.thickness = 4.0;
            paintController.drawColor = Colors.red;

            // pickerColor = Colors.red;
          },
          // style: OutlinedButton.styleFrom(
          //   shape: CircleBorder(),
          //   side: BorderSide(width: 2, color: Colors.white),
          // ),
        ),
        OutlinedButton(
          child: Container(
            color: Colors.brown,
            width: 20,
            height: 20,
          ),
          onPressed: () {
            _controller.thickness = 4.0;
            _controller.drawColor = Colors.brown;
            paintController.thickness = 4.0;
            paintController.drawColor = Colors.brown;

            // pickerColor = Colors.red;
          },
          // style: OutlinedButton.styleFrom(
          //   shape: CircleBorder(),
          //   side: BorderSide(width: 2, color: Colors.white),
          // ),
        ),
        OutlinedButton(
          child: Container(
            color: Colors.white,
            width: 20,
            height: 20,
          ),
          onPressed: () {
            _controller.backgroundColor = Colors.transparent;
            paintController.backgroundColor = Colors.transparent;
            // pickerColor = Colors.red;
          },
          // style: OutlinedButton.styleFrom(
          //   shape: CircleBorder(),
          //   side: BorderSide(width: 2, color: Colors.white),
          // ),
        ),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
        icon: new Icon(_iconData, color: _color),
        tooltip: widget._background
            ? 'Change background color'
            : 'Change draw color',
        onPressed: _pickColor);
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(new MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return new Scaffold(
                  appBar: new AppBar(
                    title: const Text('Pick color'),
                  ),
                  body: new Container(
                      alignment: Alignment.center,
                      child: new ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}

class MyPainter extends CustomPainter {
  Color? lineColor;
  Color? completeColor;
  double? completePercent;
  double? width;
  MyPainter(
      {this.lineColor, this.completeColor, this.completePercent, this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width!;
    Paint complete = new Paint()
      ..color = completeColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width!;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = 50;
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * (completePercent! / 100);
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// Самописный виджет, который возвращает через калбэк размеры чилдрена
class SizeProviderWidget extends StatefulWidget {
  final Widget? child;
  final Function(Size)? onChildSize;

  const SizeProviderWidget({Key? key, this.onChildSize, this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.onChildSize!(context.size!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

class MyPainter2 extends CustomPainter {
  MyPainter2(this.sweepAngle, this.color);
  final double? sweepAngle;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 200.0 // 1.
      ..style = PaintingStyle.stroke // 2.
      ..color = color!; // 3.

    double degToRad(double deg) => deg * (20 / 180.0);

    final path = Path()
      ..arcTo(
          // 4.
          Rect.fromCenter(
            center: Offset(size.height * 2, size.width * 2),
            height: size.height,
            width: size.width,
          ), // 5.
          degToRad(1), // 6.
          degToRad(sweepAngle!), // 7.
          false);

    canvas.drawPath(path, paint);
    canvas.drawColor(Colors.red.withOpacity(0.9), BlendMode.color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// class MyLayoutBuilder extends StatelessWidget {
//   final Widget? sizeWidget;
//   final Widget? child;
//   const MyLayoutBuilder({this.sizeWidget, this.child});

//   @override
//   Widget build(BuildContext context) {
    
//     LayoutBuilder(builder: (context, constraints) {
//       debugPrint(
//           'Max height: ${constraints.maxHeight}, max width: ${constraints.maxWidth}');
//           maxHeight = constraints.maxHeight;
//           maxWidth = constraints.maxWidth;
//       return sizeWidget!; // create function here to adapt to the parent widget's constraints
//     });
//     return Container(
//         color: Colors.green.withOpacity(0.5),
//         // height: 384,
//         // width: 586,
//         // height: imageWidth,
//         // width: imageHeight,
//         height: maxHeight,
//         width: maxWidth,
//         // height: MediaQuery.of(context).size.height *
//         //     leftSplitterWidth,
//         // width: MediaQuery.of(context).size.width *
//         //     leftSplitterWidth,
//         // width: 400,
//         child: child!);
//   }
// }

typedef void OnWidgetSizeChange(Size size);

// class MeasureSizeRenderObject extends RenderProxyBox {
//   Size oldSize;
//   final OnWidgetSizeChange onChange;

//   MeasureSizeRenderObject(this.onChange);

//   @override
//   void performLayout() {
//     super.performLayout();

//     Size newSize = child.size;
//     if (oldSize == newSize) return;

//     oldSize = newSize;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       onChange(newSize);
//     });
//   }
// }

// class MeasureSize extends SingleChildRenderObjectWidget {
//   final OnWidgetSizeChange onChange;

//   const MeasureSize({
//     Key key,
//     @required this.onChange,
//     @required Widget child,
//   }) : super(key: key, child: child);

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return MeasureSizeRenderObject(onChange);
//   }
// }
