import 'package:MWPX/data_structure/card/body/vacation/VacationCard.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:MWPX/views/home_folders/input_screen/input_screen.dart';
import 'package:MWPX/widgets/MWPGroupsBox.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/MWPAttribute.dart';
import 'package:MWPX/widgets/MWPGroupBox.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:split_view/split_view.dart';
import '../../widgets/app_bar/appbar.dart';
import 'package:MWPX/constants.dart' as Constants;

class VacationView extends StatefulWidget {
  @override
  _VacationViewState createState() => _VacationViewState();
}

class _VacationViewState extends State<VacationView> {
  int _selectedIndex = 0;
  VacationCard _selectedCard = new VacationCard();
  double rightSplitterWidth = 0.5;

  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('Отпуска', false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameVacations);

    List<VacationCard> cardList = [];

    for (int i = 0; i < 100; i++) {
      var card = new VacationCard();

      card.emplName = "Иванов$i Иван Иваанович$i";
      card.emplPodr = "Подразделение $i";
      card.emplState = "Должность$i";
      card.begDA = DateTime.now().add(new Duration(days: i));
      card.endDA = card.begDA.add(Duration(days: 5));
      card.calendarDays = i;
      card.intnlFlag = (i.remainder(3) == 0 ? "D" : "I");
      card.location = "Город00$i";
      card.unpaidFlag = (i.remainder(4) == 0);
      card.substName = "Зам$i Замович$i Замов$i";
      card.addInfText = "Отпускная$i дополнительная информация номер 000$i";
      card.resolutionText = "";
      card.signerName = "";
      card.signerDepartment = "";

      cardList.add(card);
    }

    List<Widget> vacationList = [];

    for (int i = 0; i < cardList.length; i++) {
      bool isLight = (i.remainder(2) == 0);
      bool isSelected = false;

      if (_selectedIndex == i) {
        isSelected = true;
        _selectedCard = cardList[i];
      }

      vacationList.add(GestureDetector(
          onTap: () => _selectItem(i),
          child: VacationListItem(cardList[i], isLight, isSelected)));
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
                      children: vacationList,
                    ),
                  ),
                  Container(
                    child: VacationCardView(
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
class VacationCardView extends StatefulWidget {
  final VacationCard card;
  final double? rightSplitterWidth;

  VacationCardView(this.card, {this.rightSplitterWidth});

  @override
  State<VacationCardView> createState() => _VacationCardViewState();
}

class _VacationCardViewState extends State<VacationCardView> {
  // final TextEditingController resolutionController =
  //     TextEditingController(text: '');
  String resolutionContentText = '';

  double getWeightLimit(double sizeHeight) {
    if (sizeHeight >= 768 && sizeHeight < 1024) {
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

  Widget getBusinessTripContent({double? width}) {
    return SingleChildScrollView(
      child:
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MWPAttribute(
                'Вид отпуска',
                this.widget.card.vacationTypeText,
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
              MWPAttribute(
                'Сотрудник',
                this.widget.card.getShortFIO(this.widget.card.emplName),
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
              MWPAttribute(
                'Подразделение',
                this.widget.card.emplPodr,
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
              MWPAttribute(
                'Должность',
                this.widget.card.emplState,
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
                'Место назначения',
                this.widget.card.location,
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
              MWPAttribute(
                'Замещающий',
                this.widget.card.getShortFIO(
                      this.widget.card.substName,
                    ),
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
              MWPAttribute(
                'Период',
                this.widget.card.vacationPeriodText,
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
              MWPAttribute(
                'Продолжительность',
                this.widget.card.calendarDaysText,
                containerWidth: width,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    // print('resolutionContentForDialog ${resolutionController.text}');
    // print('rightSplitterWidth in VacationCardView $rightSplitterWidth');
    // print('MediaQuery.of(context).size.width * rightSplitterWidth! ${MediaQuery.of(context).size.width * rightSplitterWidth!}');
    // print(
    // 'MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}');
    // print(
    //     'MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}');
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

    // Контент Доп. инфо
    Widget additionalInformationContent = Container(
      child: Text(
        this.widget.card.addInfText,
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
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

    // Widget resolutionContentForDialog = Text('${resolutionController.text}');

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
              'Отпуск',
              businessTribSplitterContent,
              contentWidgetForDialog: businessTribDialogContent,
            ),
          ),
          MWPGroupBox(
            'Доп.информация',
            additionalInformationContent,
            contentWidgetForDialog: additionalInformationContent,
          ),
          MWPGroupBox(
            'Согласование',
            agreementContent,
            contentWidgetForDialog: agreementContent,
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
class VacationListItem extends StatelessWidget {
  final VacationCard _card;

  final bool _isLight;
  final bool _isSelected;

  VacationListItem(this._card, this._isLight, this._isSelected);

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
                    _card.emplName,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 35,
                  child: Text(
                    _card.emplPodrStateText,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ),
              // Expanded(
              //   child: SizedBox(),
              // ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 35,
                  child: Text(
                    _card.vacationPeriodText,
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
