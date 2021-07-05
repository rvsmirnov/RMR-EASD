import 'package:MWPX/data_structure/card/body/btrip/BTripCard.dart';
import 'package:MWPX/views/home_folders/input_screen/input_screen.dart';
import 'package:MWPX/widgets/MWPGroupsBox.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/MWPAttribute.dart';
import 'package:MWPX/widgets/MWPGroupBox.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:split_view/split_view.dart';
import '../../widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/constants.dart' as Constants;

class BTripView extends StatefulWidget {
  @override
  _BTripViewState createState() => _BTripViewState();
}

class _BTripViewState extends State<BTripView> {
  int _selectedIndex = 0;
  BTripCard _selectedCard = new BTripCard();
  double rightSplitterWidth = 0.5;

  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('Командировки', false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameBTrips);

    List<BTripCard> cardList = [];

    for (int i = 0; i < 100; i++) {
      var card = new BTripCard();

      card.isInternational = (i.remainder(3) == 0);
      card.countryText = "Страна 00$i";
      card.nCity = "Город $i";
      card.begDT = DateTime.now().add(new Duration(days: i));
      card.endDT = card.begDT.add(Duration(days: 5));
      card.calendarDays = i;
      card.transportType = "Поезд номер 00$i";
      card.globalFlag = false;
      card.planPunkt = "1.$i";
      card.planFlag = false;
      card.resText = "";
      card.goalText = "Цель командировки $i";
      card.addInfText = "Дополнительная информациЯ $i";

      cardList.add(card);
    }

    List<Widget> btripList = [];

    for (int i = 0; i < cardList.length; i++) {
      bool isLight = (i.remainder(2) == 0);
      bool isSelected = false;

      if (_selectedIndex == i) {
        isSelected = true;
        _selectedCard = cardList[i];
      }

      btripList.add(GestureDetector(
          onTap: () => _selectItem(i),
          child: BTripListItem(cardList[i], isLight, isSelected)));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Column(
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
                  // print('rightSplitterWidth $rightSplitterWidth');
                }),
                viewMode: SplitViewMode.Horizontal,
                activeIndicator: SplitIndicator(
                  viewMode: SplitViewMode.Horizontal,
                  isActive: true,
                ),
                children: [
                  Container(
                    // width: 400,
                    child: ListView(
                      children: btripList,
                    ),
                  ),
                  Container(
                    child: BTripCardView(
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
  }

  _selectItem(int i) {
    print("Selected $i row");
    _selectedIndex = i;
    setState(() {});
  }
}

/// Карточка командировки, правая часть экрана
class BTripCardView extends StatefulWidget {
  final BTripCard card;
  final double? rightSplitterWidth;

  BTripCardView(this.card, {this.rightSplitterWidth});

  @override
  State<BTripCardView> createState() => _BTripCardViewState();
}

class _BTripCardViewState extends State<BTripCardView> {
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

    // return 0.004;
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

  Widget getBusinessTripContent({double? width}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MWPAttribute(
                    'Вид командировки',
                    this.widget.card.isInternationalText,
                    containerWidth: width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MWPAttribute(
                    'Город',
                    this.widget.card.nCity,
                    containerWidth: width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MWPAttribute(
                    'Продолжительность',
                    this.widget.card.calendarDaysText,
                    containerWidth: width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MWPAttribute(
                    'Вид транспорта',
                    this.widget.card.transportType,
                    containerWidth: width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
            // ),
          ),
          MWPAttribute(
            'Период',
            'с ' +
                this.widget.card.begDTText +
                ' по ' +
                this.widget.card.endDTText,
            containerWidth: width! * 2,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    // print('resolutionContentForDialog ${resolutionController.text}');
    // print('rightSplitterWidth in BTripCardView $rightSplitterWidth');
    // print('MediaQuery.of(context).size.width * rightSplitterWidth! ${MediaQuery.of(context).size.width * rightSplitterWidth!}');
    // print(
    // 'MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}');
    print(
        'MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}');
    print(
        'MediaQuery.of(context).viewInsets.bottom ${MediaQuery.of(context).viewInsets.bottom}');
    // print(
    //     'MediaQuery.of(context).size.height*0.00064 ${MediaQuery.of(context).size.height * 0.00064}');

    double mediaQueryWidth = MediaQuery.of(context).size.width;
    double minWeightLimit = getWeightLimit(MediaQuery.of(context).size.height);
    double splitterContainerWidth = getWeightMWPAttribute(
      size: mediaQueryWidth,
      fullScreen: false,
      rightSplitterWidth: widget.rightSplitterWidth,
    );
    double fullContainerWidth = getWeightMWPAttribute(
      size: mediaQueryWidth,
      fullScreen: true,
      rightSplitterWidth: widget.rightSplitterWidth,
    );

    // Контент Командировок для сплиттера
    Widget businessTribSplitterContent =
        getBusinessTripContent(width: splitterContainerWidth);
    // Контент Командировок для диалога
    Widget businessTribDialogContent =
        getBusinessTripContent(width: fullContainerWidth);

    // Контент Цель
    Widget targetContent = Text(
      this.widget.card.goalText,
      overflow: TextOverflow.visible,
      maxLines: 1,
    );

    // Контент Доп. инфо
    Widget additionalInformationContent = Container(
      child: Text(
        this.widget.card.addInfText,
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );

    // Контент Делегация
    Widget delegationContent = Table(
      border: TableBorder.symmetric(
        inside: BorderSide(width: 1),
        outside: BorderSide(width: 1),
      ),
      columnWidths: const <int, TableColumnWidth>{
        // 0: IntrinsicColumnWidth(),
        // 1: FlexColumnWidth(),
        // 2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(75, 75, 75, 1),
          ),
          children: <Widget>[
            Container(
              child: Text(
                'ФИО',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
            Container(
              child: Text(
                'Подразделение',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
            Container(
              child: Text(
                'Должность',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          children: <Widget>[
            Container(
              child: Text(
                'Кузьмина Ольга Юрьевна',
                style: TextStyle(),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
            Container(
              child: Text(
                'ЦН_тест',
                style: TextStyle(),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
            Container(
              child: Text(
                'Главный специалист',
                style: TextStyle(),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );

    // Контент Согласование
    Widget agreementContent = Table(
      border: TableBorder.symmetric(
        inside: BorderSide(width: 1),
        outside: BorderSide(width: 1),
      ),
      columnWidths: const <int, TableColumnWidth>{
        // 0: IntrinsicColumnWidth(),
        // 1: FlexColumnWidth(),
        // 2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: const BoxDecoration(
            // color: Colors.black87,
            color: Color.fromRGBO(75, 75, 75, 1),
          ),
          children: <Widget>[
            Container(
              child: Text(
                'Статус',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
            Container(
              child: Text(
                'Подразделение',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
            Container(
              child: Text(
                'Согласующий',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
            Container(
              child: Text(
                'Замечания/Комментарий',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          children: <Widget>[
            Container(
              child: Icon(
                Icons.check,
                color: Colors.green,
                size: 30,
              ),
            ),
            Container(
              child: Text(
                'ЦН_тест',
                style: TextStyle(),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
            Container(
              child: Text(
                'Денисов Петр Феликсович',
                style: TextStyle(),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
            Container(
              child: Text(
                '27.03Ю2019 10:34:00 Денисов П.Ф. 1255ghjjshsgssh',
                style: TextStyle(),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );

    // Контент Резолюция
    Widget resolutionContent = GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => InputScreen(
        //       textFieldContent: resolutionContentText,
        //       onPressed: (String str) {
        //         Navigator.of(context).pop();
        //         setState(() {
        //           resolutionContentText = str;
        //         });
        //       },
        //     ),
        //   ),
        // );
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

    return Container(
      child: SplitView(
        controller: SplitViewController(limits: [
          WeightLimit(min: minWeightLimit),
          WeightLimit(min: minWeightLimit),
          WeightLimit(min: minWeightLimit),
          WeightLimit(min: minWeightLimit),
          WeightLimit(min: minWeightLimit),
        ]),
        gripColor: Colors.white,
        viewMode: SplitViewMode.Vertical,
        activeIndicator: SplitIndicator(
          viewMode: SplitViewMode.Vertical,
          isActive: true,
        ),
        children: [
          Container(
            width:
                MediaQuery.of(context).size.width * widget.rightSplitterWidth!,
            child: MWPGroupBox(
              'Командировка',
              businessTribSplitterContent,
              contentWidgetForDialog: businessTribDialogContent,
            ),
          ),
          MWPGroupBox(
            'Цель',
            targetContent,
            contentWidgetForDialog: targetContent,
          ),
          MWPGroupBox(
            'Доп.информация',
            additionalInformationContent,
            contentWidgetForDialog: additionalInformationContent,
          ),
          MWPGroupsBox(
            'Делегация',
            delegationContent,
            'Согласование',
            agreementContent,
            contentPadding: EdgeInsets.all(0),
          ),
          MWPGroupBox(
            'Резолюция',
            resolutionContent,
            contentWidgetForDialog: Text('$resolutionContentText'),
            contentPadding: EdgeInsets.all(0),
          ),
        ],
      ),
    );
  }
}

/// Список делегатов командировки
class BTripDelegation extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container();
  }
}

/// Элемент списка командировок
class BTripListItem extends StatelessWidget {
  final BTripCard _card;

  final bool _isLight;
  final bool _isSelected;

  BTripListItem(this._card, this._isLight, this._isSelected);

  @override
  Widget build(BuildContext context) {
    Color backColor;
    if (_isSelected) {
      backColor = MWPColors.mwpAccentColorLight;
    } else {
      if (_isLight)
        backColor = new Color.fromARGB(255, 247, 247, 247);
      else
        backColor = new Color.fromARGB(255, 226, 226, 226);
    }

    return Container(
      padding: EdgeInsets.only(right: 7, left: 7, top: 14, bottom: 14),
      width: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0), color: backColor),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 35,
                  child: Text(
                    _card.nCity,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 35,
                  child: Text(
                    _card.begDTText,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 25),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 35,
                  child: Text(
                    _card.countryText,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 35,
                  child: Text(
                    _card.calendarDaysText,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
