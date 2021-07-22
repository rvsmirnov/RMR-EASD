import 'dart:typed_data';

import 'package:MWPX/blocs/home_folders/agreement/agreement_card/agreement_card_bloc.dart';
import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';
import 'package:MWPX/services/icons_service.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:MWPX/widgets/button/rounded_button2.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/MWPGroupBox.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:printing/printing.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AgreementCard extends StatelessWidget {
  final List<DataGridCell<dynamic>>? cellsList;

  const AgreementCard({
    this.cellsList,
  });

  @override
  Widget build(BuildContext context) {
    print('---0--- cellsList in AgreementCard $cellsList');
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На согласование', false, true);
    ReportService reportService = Provider.of<ReportService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: BlocProvider(
        create: (BuildContext context) => AgreementCardBloc(
          reportService: reportService,
        )..add(OpenScreen()),
        child: AgreementCardBody(
          cellsList: cellsList,
        ),
      ),
    );
  }
}

class AgreementCardBody extends StatefulWidget {
  final List<DataGridCell<dynamic>>? cellsList;

  const AgreementCardBody({
    this.cellsList,
  });

  @override
  State<AgreementCardBody> createState() => _AgreementCardBodyState();
}

class _AgreementCardBodyState extends State<AgreementCardBody> {
  IncomingCard _selectedCard = new IncomingCard();
  double rightSplitterWidth = 0.5;
  double leftSplitterWidth = 0.5;

  @override
  Widget build(BuildContext context) {
    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameBTrips);

    return BlocConsumer<AgreementCardBloc, AgreementCardState>(
      listener: (context, state) {
        if (state is AgreementCardFailure) {
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
      },
      builder: (context, state) {
        return Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: SplitView(
                    gripColor: Colors.white,
                    controller: SplitViewController(limits: [
                      WeightLimit(min: 0.02),
                      WeightLimit(min: 0.02),
                    ]),
                    onWeightChanged: (w) => setState(() {
                      rightSplitterWidth = w[1]!.toDouble();
                      leftSplitterWidth = w[0]!.toDouble();
                      // print('rightSplitterWidth $rightSplitterWidth');
                    }),
                    viewMode: SplitViewMode.Horizontal,
                    activeIndicator: SplitIndicator(
                      viewMode: SplitViewMode.Horizontal,
                      isActive: true,
                    ),
                    children: [
                      Container(
                          child: LeftCardView(
                        _selectedCard,
                        leftSplitterWidth: leftSplitterWidth,
                        cellsList: widget.cellsList,
                      )),
                      Container(
                        child: RightCardView(
                          _selectedCard,
                          rightSplitterWidth: rightSplitterWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                buttonBar
              ]),
        );
      },
    );
  }
}

class LeftCardView extends StatefulWidget {
  final IncomingCard card;
  final double? leftSplitterWidth;
  final List<DataGridCell<dynamic>>? cellsList;

  LeftCardView(this.card, {this.leftSplitterWidth, this.cellsList});

  @override
  State<LeftCardView> createState() => _LeftCardViewState();
}

class _LeftCardViewState extends State<LeftCardView> {
  PainterController _controller = _newController();
  PainterController paintController = _newPaintController();
  bool checkedValue = false;
  List<Map> imageList = <Map>[];
  double? imageHeight;
  double? imageWidth;

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

  @override
  Widget build(BuildContext context) {
    // print('screen width ${MediaQuery.of(context).size.width}');
    List<String> fileNameList = [];

    for (int i = 1; i < 10; i++) {
      fileNameList.add('$i. Название документа из файлов');
    }

    List<TableRow> tableRowList = <TableRow>[];

    DateFormat dateFormat = DateFormat("dd.MM.yyyy");
    for (int i = 1; i < 100; i++) {
      tableRowList.add(TableRow(
        decoration: i == 1
            ? const BoxDecoration(color: MWPColors.mwpTableRowGreenBackground)
            : const BoxDecoration(color: Colors.white),
        children: <Widget>[
          Container(
            child: Text(
              'Кузьмина Ольга Юрьевна $i ЦН',
              style: TextStyle(),
              overflow: TextOverflow.visible,
              maxLines: 2,
            ),
          ),
          Row(
            children: [
              Container(
                child: i % 2 != 0
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 30,
                      )
                    : Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 30,
                      ),
              ),
              Container(
                child: Text(
                  dateFormat
                      .format(DateTime.now().add(new Duration(days: 1 * i)))
                      .toString(),
                  style: TextStyle(),
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              'Текст замечания $i',
              style: TextStyle(),
              overflow: TextOverflow.visible,
              maxLines: 2,
            ),
          ),
        ],
      ));
    }

    Widget leftHeaderContent = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Checkbox(
          value: checkedValue,
          onChanged: (bool? newValue) {
            setState(() {
              checkedValue = newValue!;
            });
          },
        ),
        Text(
          'К совещанию',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: RoundedButton2(
            onPressed: () {
              Dialogs.infoDialogRK(
                context: context,
                titleWidget: Column(
                  children: [
                    Row(
                      children: [
                        IconsService.getIconRK(widget.cellsList![1].value),
                        //этого свойства нет в нашей таблице и поэтому сюда не передаем
                        // agreementItem.documentType = '';
                        // agreementItem.documentTypeText = '';
                        Text(
                          '${widget.cellsList![2].value}',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Исполнитель: Иванов Аркадий Петрович ${widget.cellsList![4].value}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Получено: ${widget.cellsList![1].value}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                content: Text(
                    '${widget.cellsList![5].value.toString()} doknr: ${widget.cellsList![6].value.toString()} dokvr: ${widget.cellsList![7].value.toString()} doktl: ${widget.cellsList![8].value.toString()} wfItem: ${widget.cellsList![8].value.toString()}'),
              );
            },
            child: Center(
              child: Container(
                // height: 20,
                child: Text(
                  'РК',
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        // В вертикальной ориентации это не работает
        // Поэтому сделать условие, что если вертикальная ориентация, то
        widget.leftSplitterWidth! < 0.45
            ? SizedBox()
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: RoundedButton2(
                    onPressed: () {
                      Dialogs.infoDialogRK(
                        context: context,
                        titleWidget: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Лист согласования',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: Table(
                            border: TableBorder.symmetric(
                              inside: BorderSide(width: 1),
                              outside: BorderSide(width: 1),
                            ),
                            columnWidths: const <int, TableColumnWidth>{
                              // 0: IntrinsicColumnWidth(),
                              // 1: FlexColumnWidth(),
                              // 2: FixedColumnWidth(64),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(75, 75, 75, 1),
                                ),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(
                                      'Согласующий',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Согласование',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Текст замечания',
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              ...tableRowList
                            ],
                          ),
                        ),
                      );
                    },
                    // width: 360*widget.leftSplitterWidth!,
                    width: 160,
                    height: 40,
                    child: Center(
                      child: Container(
                        // height: 20,
                        child: Text(
                          'Лист согласования',
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );

    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 57,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: checkedValue,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    checkedValue = newValue!;
                                  });
                                },
                              ),
                              RoundedButton2(
                                onPressed: () {},
                                child: Icon(
                                  Icons.insert_drive_file,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: RoundedButton2(
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MediaQuery.of(context).size.width < 900
                          ? Expanded(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: leftHeaderContent),
                            )
                          : widget.leftSplitterWidth! < 0.3
                              ? Expanded(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: leftHeaderContent),
                                )
                              : leftHeaderContent
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 5.5,
                  child: Wrap(
                    clipBehavior: Clip.hardEdge,
                    direction: Axis.horizontal,
                    children: [
                      ...fileNameList.map(
                        (e) => Container(
                          width: MediaQuery.of(context).size.width /
                              2.5 *
                              widget.leftSplitterWidth!,
                          child: Row(
                            children: [
                              widget.leftSplitterWidth! < 0.2
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Checkbox(
                                          value: checkedValue,
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              checkedValue = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  : Checkbox(
                                      value: checkedValue,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          checkedValue = newValue!;
                                        });
                                      },
                                    ),
                              widget.leftSplitterWidth! < 0.3
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 3, 0),
                                          child:
                                              FaIcon(FontAwesomeIcons.fileWord),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      child: FaIcon(FontAwesomeIcons.fileWord),
                                    ),
                              Expanded(
                                child: Text(
                                  e,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  color: Colors.black12,
                ),
                Expanded(
                  child: ListView.builder(
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
                      paintController.backgroundColor =
                          _controller.backgroundColor;
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
                        return Stack(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Transform.scale(
                                alignment: Alignment.topLeft,
                                scale: 2 * widget.leftSplitterWidth!,
                                child: Container(
                                    color: Colors.blue.withOpacity(0.5),
                                    child: e['image']),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Transform.scale(
                                alignment: Alignment.topLeft,
                                scale: 2 * widget.leftSplitterWidth!,
                                child: Container(
                                  color: Colors.green.withOpacity(0.5),
                                  height: 586,
                                  width: 394,
                                  child: new Painter(
                                    paintController,
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
              ],
            ),
          ),
        ),
        widget.leftSplitterWidth! < 0.1
            ? SizedBox()
            : Container(
                width: 50,
                color: Colors.black12,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: MWPCircleButton(
                        backgroundColor: Colors.white,
                        buttonChild: Icon(
                          Icons.get_app,
                          color: Colors.black87,
                          size: 18,
                        ),
                        onPressed: () {},
                        borderWidth: 2,
                        borderColor: Colors.black87,
                        rotationIndex: 2,
                      ),
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: FaIcon(
                        FontAwesomeIcons.chevronUp,
                        color: Colors.black,
                        size: 22,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                    Expanded(child: Container()),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: FaIcon(
                        FontAwesomeIcons.handPointUp,
                        color: Colors.black,
                        size: 22,
                      ),
                      // Это временный код
                      onPressed: () async {
                        List<Map> list = <Map>[];

                        ByteData bd =
                            await rootBundle.load('assets/files/232.pdf');

                        await for (var page in Printing.raster(
                            bd.buffer.asUint8List(),
                            dpi: 72)) {
                          final page1 = await page.toPng();
                          Image image = Image.memory(page1);
                          var decodedImage = await decodeImageFromList(page1);
                          int imgWidth = decodedImage.width;
                          int imgHeight = decodedImage.height;
                          print('-- imgWidth $imgWidth imgHeight $imgHeight');
                          setState(() {
                            imageHeight = double.parse(imgHeight.toString());
                            imageWidth = double.parse(imgWidth.toString());
                          });
                          PainterController controller = _newController();
                          Map imageAndController = {
                            'image': image,
                            'controller': controller,
                          };
                          list.add(imageAndController);

                          print('0 list count ${list.length}');
                        }
                        print('2 list count ${list.length}');
                        setState(() {
                          imageList = list;
                        });
                      },
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: Icon(
                        Icons.mode_edit,
                        color: Colors.black87,
                        size: 18,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: Icon(
                        Icons.create,
                        color: Colors.deepOrange[900],
                        size: 18,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: Icon(
                        Icons.label,
                        color: Colors.black87,
                        size: 18,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                      rotationIndex: 1,
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: Icon(
                        Icons.redo,
                        color: Colors.black87,
                        size: 18,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: Icon(
                        Icons.cancel,
                        color: Colors.red[700],
                        size: 18,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                    Expanded(child: Container()),
                    MWPCircleButton(
                      buttonChild: FaIcon(
                        FontAwesomeIcons.chevronDown,
                        color: Colors.black,
                        size: 22,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                      backgroundColor: Colors.white,
                    ),
                    MWPCircleButton(
                      backgroundColor: Colors.white,
                      buttonChild: Icon(
                        Icons.get_app,
                        color: Colors.black87,
                        size: 18,
                      ),
                      onPressed: () {},
                      borderWidth: 2,
                      borderColor: Colors.black87,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

/// Карточка командировки, правая часть экрана
class RightCardView extends StatefulWidget {
  final IncomingCard card;
  final double? rightSplitterWidth;

  RightCardView(this.card, {this.rightSplitterWidth});

  @override
  State<RightCardView> createState() => _RightCardViewState();
}

class _RightCardViewState extends State<RightCardView> {
  String resolutionContentText = '';

  double getWeightLimit(double sizeHeight) {
    if (sizeHeight >= 320 && sizeHeight < 768) {
      return 0.3;
    } else if (sizeHeight >= 768 && sizeHeight < 1024) {
      return 0.104;
    } else if (sizeHeight >= 1024) {
      return 0.072;
    }
    return 0.104;
  }

  double getWeightMWPAttribute(
      {double? size, bool? fullScreen, double? rightSplitterWidth}) {
    if (fullScreen!) {
      return size! / 2.5;
    } else {
      return size! / 2 * rightSplitterWidth! - 50 >= 0
          ? size / 2 * rightSplitterWidth - 50
          : 0;
    }
  }

  Widget build(BuildContext context) {
    double minWeightLimit = getWeightLimit(MediaQuery.of(context).size.height);

    // Контент Доп. информация
    Widget additionalInformationContent = Container(
      child: Text(
        'this.widget.card.addInfText',
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );

    // Контент Резолюция
    Widget resolutionContent = GestureDetector(
      onTap: () {
        Dialogs.inputDialog(
          context: context,
          title: 'eee',
          content: resolutionContentText,
          onPressed: (String str) {
            setState(() {
              resolutionContentText = str;
            });
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 250),
          border: Border.all(color: Colors.black, width: 1),
        ),
        padding: EdgeInsets.fromLTRB(7, 0, 7, 3),
        child: Text('$resolutionContentText'),
      ),
    );

    // Контент Голосовые заметки
    Widget voiceNotesContent = Container(
      child: Text(
        'Список голосовых заметок voiceNotesTable',
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );

    return Container(
      child: SplitView(
        controller: SplitViewController(limits: [
          WeightLimit(min: minWeightLimit),
          WeightLimit(min: minWeightLimit),
          WeightLimit(min: minWeightLimit),
          // WeightLimit(min: minWeightLimit),
          // WeightLimit(min: minWeightLimit),
        ]),
        gripColor: Colors.white,
        viewMode: SplitViewMode.Vertical,
        activeIndicator: SplitIndicator(
          viewMode: SplitViewMode.Vertical,
          isActive: true,
        ),
        children: [
          MWPGroupBox(
            'Доп.информация',
            additionalInformationContent,
            contentWidgetForDialog: additionalInformationContent,
            titleDecorationOn: false,
            infoDialogIconOn: false,
            buttonsList: [
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 34,
                ),
                onPressed: () {},
                borderWidth: 2,
                borderColor: Colors.black,
              )
            ],
          ),
          MWPGroupBox(
            'Резолюция',
            resolutionContent,
            contentWidgetForDialog: Text('$resolutionContentText'),
            contentPadding: EdgeInsets.all(0),
            titleDecorationOn: false,
            infoDialogIconOn: false,
            buttonsList: [
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.content_paste,
                  color: Colors.black87,
                  // size: 34,
                ),
                onPressed: () {},
                borderWidth: 2,
                borderColor: Colors.black87,
              ),
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.person_add,
                  color: Colors.black,
                  // size: 34,
                ),
                onPressed: () {},
                borderWidth: 2,
                borderColor: Colors.black,
              )
            ],
          ),
          MWPGroupBox(
            'Голосовые заметки',
            voiceNotesContent,
            contentWidgetForDialog: voiceNotesContent,
            titleDecorationOn: false,
            infoDialogIconOn: false,
            buttonsList: [
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.keyboard_voice_sharp,
                  color: Colors.redAccent[700],
                ),
                onPressed: () {},
                borderWidth: 2,
                borderColor: Colors.redAccent[700],
              ),
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.volume_up,
                  color: Colors.black,
                ),
                onPressed: () {},
                borderWidth: 2,
                borderColor: Colors.black,
              ),
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {},
                borderWidth: 2,
                borderColor: Colors.black,
              )
            ],
          ),
        ],
      ),
    );
  }
}
