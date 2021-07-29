import 'dart:typed_data';

import 'package:MWPX/blocs/rk_card/rk_card_bloc.dart';
import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';
import 'package:MWPX/services/audio_service.dart';
import 'package:MWPX/services/file_service.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/views/rk_card/rk_dialogs/btrip_dialogs.dart';
import 'package:MWPX/views/rk_card/rk_dialogs/vacation_dialogs.dart';
import 'package:MWPX/views/rk_card/rk_left_header.dart';
import 'package:MWPX/views/rk_card/rk_left_header_simple.dart';
import 'package:MWPX/views/rk_card/rk_left_header_simple_light.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:MWPX/widgets/timer/count_down_timer.dart';
import 'package:MWPX/widgets/timer/count_up_timer.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/MWPGroupBox.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:printing/printing.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RKCard extends StatelessWidget {
  final List<DataGridCell<dynamic>>? cellsList;
  final String? cardTitle;
  final String? dokar;

  const RKCard({
    this.cellsList,
    this.cardTitle = '',
    this.dokar = '',
  });

  @override
  Widget build(BuildContext context) {
    // print('---0--- cellsList in RKCard $cellsList');
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar(cardTitle!, false, true);
    ReportService reportService = Provider.of<ReportService>(context);
    AudioService? audioService = Provider.of<AudioService>(context);
    FileService? fileService = Provider.of<FileService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: BlocProvider(
        create: (BuildContext context) => RKCardBloc(
          reportService: reportService,
          audioService: audioService,
          fileService: fileService,
        )..add(OpenScreen()),
        child: RKCardBody(
          cellsList: cellsList,
          dokar: dokar,
        ),
      ),
    );
  }
}

class RKCardBody extends StatefulWidget {
  final String? dokar;
  final List<DataGridCell<dynamic>>? cellsList;

  const RKCardBody({
    this.dokar = '',
    this.cellsList,
  });

  @override
  State<RKCardBody> createState() => _RKCardBodyState();
}

class _RKCardBodyState extends State<RKCardBody> {
  IncomingCard _selectedCard = new IncomingCard();
  double rightSplitterWidth = 0.5;
  double leftSplitterWidth = 0.5;
  List<String> numberVoiceList = <String>[];
  String selectedVoiceNumber = '';

  @override
  Widget build(BuildContext context) {
    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameBTrips);

    return BlocConsumer<RKCardBloc, RKCardState>(
      listener: (context, state) {
        if (state is RKCardFailure) {
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
        if (state is RKCardData) {
          numberVoiceList = state.numberVoiceList!;
          if (state.errorMessage != '') {
            Dialogs.infoDialogDarkWithRoundButton(
              context: context,
              content: Container(
                height: 120,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              buttonName: 'Ок',
              buttonFunction: () {},
            );
          }
          // print('-- listener state.resetVoiceNumber ${state.resetVoiceNumber}');
          if (state.resetVoiceNumber == true) {
            // Сбрасываем selectedVoiceNumber  до нуля
            // print('-- listener state.resetVoiceNumber == true');
            selectedVoiceNumber = '0';
          } else {
            // print('-- listener state.resetVoiceNumber == false');
            selectedVoiceNumber = '';
          }
          if (state.showRecordingDialog == true) {
            Dialogs.infoDialogDark(
              context: context,
              content: Container(
                height: 120,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Идет проигрывание голосовой заметки!',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      CountDownTimer(
                        duration: state.duration,
                      ),
                    ],
                  ),
                ),
              ),
              buttonName: 'Остановить',
              buttonFunction: () {
                BlocProvider.of<RKCardBloc>(context).add(StopPlayer());
              },
            ).then((value) =>
                BlocProvider.of<RKCardBloc>(context).add(StopPlayer()));
          }
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
                      Navigator(
                        onGenerateRoute: (settings) => MaterialPageRoute(
                          builder: (context) => Container(
                              child: LeftCardView(
                            _selectedCard,
                            leftSplitterWidth: leftSplitterWidth,
                            cellsList: widget.cellsList,
                            dokar: widget.dokar,
                          )),
                        ),
                      ),
                      // Navigator(
                      //   onGenerateRoute: (settings) => MaterialPageRoute(
                      //     builder: (context) => Container(
                      //       child: RightCardView(
                      //         _selectedCard,
                      //         rightSplitterWidth: rightSplitterWidth,
                      //         dokar: widget.dokar,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      RightCardView(
                        _selectedCard,
                        rightSplitterWidth: rightSplitterWidth,
                        dokar: widget.dokar,
                        numberVoiceList: numberVoiceList,
                        selectedVoiceNumber: selectedVoiceNumber,
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
  final String? dokar;
  final IncomingCard card;
  final double? leftSplitterWidth;
  final List<DataGridCell<dynamic>>? cellsList;

  LeftCardView(
    this.card, {
    this.leftSplitterWidth,
    this.cellsList,
    this.dokar,
  });

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
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.dokar == 'LVE') {
        VacationDilogs.getVacationRKDialog(
          context: context,
          cellsList: widget.cellsList,
        );
      }
      if (widget.dokar == 'BTR') {
        BTripDilogs.getBTripRKDialog(
          context: context,
          cellsList: widget.cellsList,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('screen width ${MediaQuery.of(context).size.width}');
    List<String> fileNameList = [];

    if (widget.dokar != 'LVE' && widget.dokar != 'BTR') {
      for (int i = 1; i < 10; i++) {
        fileNameList.add('$i. Название документа из файлов');
      }
    }

    Widget getRKLeftHeader(String dokar, BuildContext context) {
      if (dokar == 'VHD') {
        return RKSimpleLeftHeader(
          buildContext: context,
          cellsList: widget.cellsList,
          leftSplitterWidth: widget.leftSplitterWidth,
        );
      }
      if (dokar == 'ORD') {
        return RKLeftHeader(
          dokar: dokar,
          cellsList: widget.cellsList,
          leftSplitterWidth: widget.leftSplitterWidth,
          rightButtonText: 'Лист согласования',
        );
      }
      if (dokar == 'ISD') {
        return RKLeftHeader(
          dokar: dokar,
          cellsList: widget.cellsList,
          leftSplitterWidth: widget.leftSplitterWidth,
          rightButtonText: 'Лист согласования',
        );
      }
      if (dokar == 'ДКИ') {
        return RKLeftHeader(
          dokar: dokar,
          cellsList: widget.cellsList,
          leftSplitterWidth: widget.leftSplitterWidth,
          rightButtonText: 'Ход исполнения',
        );
      }
      if (dokar == 'LVE' || dokar == 'BTR') {
        return RKSimpleLightLeftHeader(
          dokar: dokar,
          buildContext: context,
          cellsList: widget.cellsList,
          leftSplitterWidth: widget.leftSplitterWidth,
        );
      }
      return SizedBox();
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRKLeftHeader(widget.dokar!, context),
                Container(
                  height: fileNameList.length < 1
                      ? 57
                      : MediaQuery.of(context).size.height / 5.5,
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
                fileNameList.length < 1
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'Прикрепленные файлы отсутствуют',
                          ),
                        ),
                      )
                    : Expanded(
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
            : widget.dokar == 'LVE' || widget.dokar == 'BTR'
                ? Container(
                    height: double.infinity,
                    width: 50,
                    color: Colors.black12,
                    child: SizedBox(),
                  )
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
                              var decodedImage =
                                  await decodeImageFromList(page1);
                              int imgWidth = decodedImage.width;
                              int imgHeight = decodedImage.height;
                              print(
                                  '-- imgWidth $imgWidth imgHeight $imgHeight');
                              setState(() {
                                imageHeight =
                                    double.parse(imgHeight.toString());
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
  final String? dokar;
  final List<String>? numberVoiceList;
  final String selectedVoiceNumber;

  RightCardView(
    this.card, {
    this.rightSplitterWidth,
    this.dokar = '',
    this.numberVoiceList,
    this.selectedVoiceNumber = '',
  });

  @override
  State<RightCardView> createState() => _RightCardViewState();
}

class _RightCardViewState extends State<RightCardView> {
  String resolutionContentText = '';
  String selectedVoiceNumber = '0';
  // Это сделано, чтобы отправить событие из dispose()
  RKCardBloc? _rkCardBloc;

  @override
  void initState() { 
    super.initState();
    // Это сделано, чтобы отправить событие из dispose()
    final RKCardBloc rkCardBloc = BlocProvider.of<RKCardBloc>(context);
    _rkCardBloc = rkCardBloc;
  }

    @override
  void dispose() {
    // Это сделано, чтобы отправить событие из dispose()
    _rkCardBloc!.add(CloseAudioSession());
    super.dispose();
  }

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

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedVoiceNumber == '0') {
      setState(() {
        selectedVoiceNumber = '0';
      });
    }
  }

  Widget build(BuildContext context) {
    double minWeightLimit = getWeightLimit(MediaQuery.of(context).size.height);
    print(
        'widget.selectedVoiceNumber in RightCardView ${widget.selectedVoiceNumber}');
    print('selectedVoiceNumber in RightCardView $selectedVoiceNumber');
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
      child: ListView.builder(
        itemCount: widget.numberVoiceList!.length,
        itemBuilder: (context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedVoiceNumber = widget.numberVoiceList![index];
              });
            },
            child: Container(
              color: widget.numberVoiceList![index] == selectedVoiceNumber
                  ? MWPColors.mwpTableRowGreenBackground
                  : Colors.white,
              child: Text(
                'Голоcовая заметка ${widget.numberVoiceList![index]}',
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
          );
        },
      ),
    );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     ...widget.numberVoiceList!.map(
    //       (e) => InkWell(
    //   onTap: () {
    //     setState(() {
    //       selectedVoiceNumber = e;
    //     });
    //   },
    //   child: Container(
    //     color: e == selectedVoiceNumber
    //         ? MWPColors.mwpTableRowGreenBackground
    //         : Colors.white,
    //     child: Text(
    //       'Голоcовая заметка $e',
    //       overflow: TextOverflow.visible,
    //       maxLines: 1,
    //     ),
    //   ),
    // );
    //     ),
    //   ],
    // ),
    // );

    String getGroupBoxName(String dokar) {
      if (dokar == 'VHD') {
        return 'Проект резолюции';
      } else {
        return 'Доп.информация';
      }
    }

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
            getGroupBoxName(widget.dokar!),
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
                onPressed: () {
                  BlocProvider.of<RKCardBloc>(context).add(StartRecording());
                  Dialogs.infoDialogDark(
                    context: context,
                    content: Container(
                      height: 120,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Говорите. Идет запись звуковой резолюции!',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            CountUpTimer(),
                          ],
                        ),
                      ),
                    ),
                    buttonName: 'Остановить',
                    buttonFunction: () {
                      BlocProvider.of<RKCardBloc>(context).add(StopRecording());
                    },
                  ).then((value) => BlocProvider.of<RKCardBloc>(context)
                      .add(StopRecording()));
                },
                borderWidth: 2,
                borderColor: Colors.redAccent[700],
              ),
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.volume_up,
                  color: Colors.black,
                ),
                onPressed: () {
                  // То есть голосовая заметка не выбрана

                  if (selectedVoiceNumber == '0') {
                    print('--1--');
                    Dialogs.infoDialogDarkWithRoundButton(
                      context: context,
                      content: Container(
                        height: 120,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Выберите голосовую резолюцию для прослушивания.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      buttonName: 'Ок',
                      buttonFunction: () {},
                    );
                  } else {
                    BlocProvider.of<RKCardBloc>(context).add(
                      StartPlayer(
                        voiceNumber: selectedVoiceNumber,
                      ),
                    );
                  }
                },
                borderWidth: 2,
                borderColor: Colors.black,
              ),
              MWPCircleButton(
                buttonChild: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (selectedVoiceNumber == '0') {
                    Dialogs.infoDialogDarkWithRoundButton(
                      context: context,
                      content: Container(
                        height: 120,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Выберите голосовую заметку для удаления.',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      buttonName: 'Ок',
                      buttonFunction: () {},
                    );
                  } else {
                    Dialogs.infoDialogDarkWithChoice(
                      context: context,
                      content: Container(
                        height: 120,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Удалить голосовую заметку?',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      buttonFunction: () {
                        // BlocProvider.of<RKCardBloc>(context).add(StopPlayer());
                      },
                    ).then((value) {
                      if (value == true) {
                        BlocProvider.of<RKCardBloc>(context).add(
                          DeleteFile(
                            voiceNumber: selectedVoiceNumber,
                          ),
                        );
                      }
                    });
                  }
                },
                borderWidth: 2,
                borderColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
