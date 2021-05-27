import 'package:flutter/material.dart';
import 'package:MWPX/controls/MWPAttribute.dart';
import 'package:MWPX/controls/MWPGroupBox.dart';
import 'package:MWPX/controls/buttonbar.dart';
import 'package:MWPX/datastructure/card/VacationCard.dart';
import '../../controls/appbar.dart';
import 'package:MWPX/constants.dart' as Constants;

import '../../mwpcolors.dart';

/// Экран отпусков
class VacationView extends StatefulWidget {
  @override
  _VacationViewState createState() => _VacationViewState();
}

class _VacationViewState extends State<VacationView> {
  int _selectedIndex = 0;
  VacationCard _selectedCard;

  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('Отпуска', null, false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameVacations);

    List<VacationCard> cardList = new List<VacationCard>();

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
      card.signerPodr = "";

      cardList.add(card);
    }

    List<Widget> vacationList = new List<Widget>();

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
      appBar: appBar,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: 500,
                      child: ListView(
                        children: vacationList,
                      ),
                    ),
                    Expanded(
                      child: VacationCardView(_selectedCard),
                    )
                  ],
                ),
              ),
            ),
            buttonBar
          ]),
    );
  }

  _selectItem(int i) {
    print("Selected $i vacation");
    _selectedIndex = i;
    setState(() {});
  }
}

/// Карточка командировки, правая часть экрана
class VacationCardView extends StatelessWidget {
  final VacationCard card;

  VacationCardView(this.card);

  Widget build(BuildContext context) {
    return Container(
      color: mwpColorWhite,
      child: Column(
        children: <Widget>[
          MWPGroupBox(
              'Отпуск',
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MWPAttribute('Вид отпуска', this.card.vacationTypeText),
                      MWPAttribute('Сотрудник',
                          this.card.getShortFIO(this.card.emplName)),
                      MWPAttribute('Подразделение', this.card.emplPodr),
                      MWPAttribute('Должность', this.card.emplState),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MWPAttribute('Место назначения', this.card.location),
                      MWPAttribute('Замещающий',
                          this.card.getShortFIO(this.card.substName)),
                      MWPAttribute('Период', this.card.vacationPeriodText),
                      MWPAttribute(
                          'Продолжительность', this.card.calendarDaysText),
                    ],
                  )
                ],
              )),
          MWPGroupBox(
              'Доп.информация',
              Container(
                child: Text(this.card.addInfText),
              )),
          MWPGroupBox('Согласование', Container()),
          MWPGroupBox('Резолюция', Container()),
        ],
      ),
    );
  }
}

/// Элемент списка отпусков
class VacationListItem extends StatelessWidget {
  final VacationCard _card;

  final bool _isLight;
  final bool _isSelected;

  VacationListItem(this._card, this._isLight, this._isSelected);

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _card.emplName,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 28),
          ),
          Text(
            _card.emplPodrStateText,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 22),
          ),
          Row(
            children: <Widget>[
              Text(
                _card.vacationPeriodText,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                _card.calendarDaysText,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20),
              )
            ],
          )
        ],
      ),
    );
  }
}
