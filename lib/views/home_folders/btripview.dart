import 'package:MWPX/widgets/MWPGroupsBox.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/MWPAttribute.dart';
import 'package:MWPX/widgets/MWPGroupBox.dart';
import 'package:MWPX/data_structure/card/BTripCard.dart';
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
  double leftSplitterWidth = 0.5;

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
                  leftSplitterWidth = w[1]!.toDouble();
                  // print('leftSplitterWidth $leftSplitterWidth');
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
                      leftSplitterWidth: leftSplitterWidth,
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
class BTripCardView extends StatelessWidget {
  final BTripCard card;
  final double? leftSplitterWidth;

  BTripCardView(this.card, {this.leftSplitterWidth});

  double getWeightLimit(double sizeHeight) {
    if (sizeHeight >= 768 && sizeHeight < 1024) {
      return 0.104;
    } else if (sizeHeight >= 1024) {
      return 0.072;
    }
    return 0.104;
  }

  Widget build(BuildContext context) {
    // print('leftSplitterWidth in BTripCardView $leftSplitterWidth');
    // print('MediaQuery.of(context).size.width * leftSplitterWidth! ${MediaQuery.of(context).size.width * leftSplitterWidth!}');
    // print('MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}');
    // print(
    //     'MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}');
    // print(
    //     'MediaQuery.of(context).size.height*0.00064 ${MediaQuery.of(context).size.height * 0.00064}');
    double minWeightLimit = getWeightLimit(MediaQuery.of(context).size.height);
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
            width: MediaQuery.of(context).size.width * leftSplitterWidth!,
            child: MWPGroupBox(
                'Командировка',
                SingleChildScrollView(
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
                                this.card.isInternationalText,
                                containerWidth:
                                    MediaQuery.of(context).size.width /
                                                    2 *
                                                    leftSplitterWidth! -
                                                50 >=
                                            0
                                        ? MediaQuery.of(context).size.width /
                                                2 *
                                                leftSplitterWidth! -
                                            50
                                        : 0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MWPAttribute(
                                'Город',
                                this.card.nCity,
                                containerWidth:
                                    MediaQuery.of(context).size.width /
                                                    2 *
                                                    leftSplitterWidth! -
                                                50 >=
                                            0
                                        ? MediaQuery.of(context).size.width /
                                                2 *
                                                leftSplitterWidth! -
                                            50
                                        : 0,
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
                                this.card.calendarDaysText,
                                containerWidth:
                                    MediaQuery.of(context).size.width /
                                                    2 *
                                                    leftSplitterWidth! -
                                                50 >=
                                            0
                                        ? MediaQuery.of(context).size.width /
                                                2 *
                                                leftSplitterWidth! -
                                            50
                                        : 0,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MWPAttribute(
                                'Вид транспорта',
                                this.card.transportType,
                                containerWidth:
                                    MediaQuery.of(context).size.width /
                                                    2 *
                                                    leftSplitterWidth! -
                                                50 >=
                                            0
                                        ? MediaQuery.of(context).size.width /
                                                2 *
                                                leftSplitterWidth! -
                                            50
                                        : 0,
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
                            this.card.begDTText +
                            ' по ' +
                            this.card.endDTText,
                        containerWidth: MediaQuery.of(context).size.width /
                                        leftSplitterWidth! -
                                    50 >=
                                0
                            ? MediaQuery.of(context).size.width /
                                    leftSplitterWidth! -
                                50
                            : 0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
          ),
          MWPGroupBox(
              'Цель',
              Text(
                this.card.goalText,
                overflow: TextOverflow.visible,
                maxLines: 1,
              )),
          MWPGroupBox(
              'Доп.информация',
              Container(
                child: Text(
                  this.card.addInfText,
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                ),
              )),
          MWPGroupsBox(
            'Делегация',
            Table(
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
                    color: Colors.black87,
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
            ),
            'Согласование',
            Table(
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
                    color: Colors.black87,
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
                      child: Icon(Icons.check, color: Colors.green, size: 30,),
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
            ),
            contentPadding: EdgeInsets.all(0),
          ),
          MWPGroupBox(
            'Резолюция',
            TextField(
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(7, 0, 7, 3),
              ),
            ),
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
      backColor = mwpAccentColorLight;
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
