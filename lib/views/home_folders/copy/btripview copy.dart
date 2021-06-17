// import 'package:flutter/material.dart';
// import 'package:MWPX/widgets/MWPAttribute.dart';
// import 'package:MWPX/widgets/MWPGroupBox.dart';
// import 'package:MWPX/data_structure/card/BTripCard.dart';
// import 'package:MWPX/styles/mwp_colors.dart';
// import 'package:flutter/rendering.dart';
// import 'package:split_view/split_view.dart';
// import '../../widgets/app_bar/appbar.dart';
// import 'package:MWPX/widgets/button_bar/buttonbar.dart';
// import 'package:MWPX/constants.dart' as Constants;

// Копия с изначальной версткой
// class BTripView extends StatefulWidget {
//   @override
//   _BTripViewState createState() => _BTripViewState();
// }

// class _BTripViewState extends State<BTripView> {
//   int _selectedIndex = 0;
//   BTripCard _selectedCard = new BTripCard();
//   double leftSplitterWidth = 0.5;

//   Widget build(BuildContext context) {
//     var appBar = new MWPMainAppBar();
//     appBar.configureAppBar('Командировки', false, true);

//     var buttonBar = new MWPButtonBar();
//     buttonBar.configureButtonBar(Constants.viewNameBTrips);

//     List<BTripCard> cardList = [];

//     for (int i = 0; i < 100; i++) {
//       var card = new BTripCard();

//       card.isInternational = (i.remainder(3) == 0);
//       card.countryText = "Страна 00$i";
//       card.nCity = "Город $i";
//       card.begDT = DateTime.now().add(new Duration(days: i));
//       card.endDT = card.begDT.add(Duration(days: 5));
//       card.calendarDays = i;
//       card.transportType = "Поезд номер 00$i";
//       card.globalFlag = false;
//       card.planPunkt = "1.$i";
//       card.planFlag = false;
//       card.resText = "";
//       card.goalText = "Цель командировки $i";
//       card.addInfText = "Дополнительная информациЯ $i";

//       cardList.add(card);
//     }

//     List<Widget> btripList = [];

//     for (int i = 0; i < cardList.length; i++) {
//       bool isLight = (i.remainder(2) == 0);
//       bool isSelected = false;

//       if (_selectedIndex == i) {
//         isSelected = true;
//         _selectedCard = cardList[i];
//       }

//       btripList.add(GestureDetector(
//           onTap: () => _selectItem(i),
//           child: BTripListItem(cardList[i], isLight, isSelected)));
//     }

//     return Scaffold(
//       appBar: appBar,
//       body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Expanded(
//               child: SplitView(
//                 controller: SplitViewController(limits: [
//                   WeightLimit(min: 0.02),
//                   WeightLimit(min: 0.02),
//                 ]),
//                 onWeightChanged: (w) => setState(() {
//                   leftSplitterWidth = w[1]!.toDouble();
//                   // print('leftSplitterWidth $leftSplitterWidth');
//                 }),
//                 viewMode: SplitViewMode.Horizontal,
//                 indicator: SplitIndicator(viewMode: SplitViewMode.Horizontal),
//                 activeIndicator: SplitIndicator(
//                   viewMode: SplitViewMode.Horizontal,
//                   isActive: true,
//                 ),
//                 children: [
//                   Container(
//                     // width: 400,
//                     child: ListView(
//                       children: btripList,
//                     ),
//                   ),
//                   Container(
//                     // decoration: BoxDecoration(border: Border.all(width: 2)),
//                     // width: 400,
//                     child: BTripCardView(
//                       _selectedCard,
//                       leftSplitterWidth: leftSplitterWidth,
//                     ),
//                   ),
//                   // Container(
//                   //   child: SizedBox(),
//                   // ),
//                 ],
//               ),
//             ),
//             buttonBar
//           ]),
//     );
//   }

//   _selectItem(int i) {
//     print("Selected $i row");
//     _selectedIndex = i;
//     setState(() {});
//   }
// }

// /// Карточка командировки, правая часть экрана
// class BTripCardView extends StatelessWidget {
//   final BTripCard card;
//   final double? leftSplitterWidth;

//   BTripCardView(this.card, {this.leftSplitterWidth});

//   Widget build(BuildContext context) {
//     // print('leftSplitterWidth in BTripCardView $leftSplitterWidth');
//     // print('MediaQuery.of(context).size.width * leftSplitterWidth! ${MediaQuery.of(context).size.width * leftSplitterWidth!}');
//     // print('MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}');

//     return Container(
//       // height: 250,
//       //   color: mwpColorWhite,
//       child: SplitView(
//         controller: SplitViewController(limits: [
//           WeightLimit(min: 0.02),
//           WeightLimit(min: 0.02),
//           WeightLimit(min: 0.02),
//           WeightLimit(min: 0.02),
//           WeightLimit(min: 0.02),
//         ]),
//         // onWeightChanged: (w) => setState(() {
//         //   leftSplitterWidth = w[1]!.toDouble();
//         //   // print('leftSplitterWidth $leftSplitterWidth');
//         // }),
//         viewMode: SplitViewMode.Vertical,
//         indicator: SplitIndicator(viewMode: SplitViewMode.Vertical),
//         activeIndicator: SplitIndicator(
//           viewMode: SplitViewMode.Vertical,
//           isActive: true,
//         ),
//         children: [
//           Container(
//             // height: 450,
//             // Было
//             // width: MediaQuery.of(context).size.width * leftSplitterWidth!,
//             width: MediaQuery.of(context).size.width * leftSplitterWidth!,
//             // leftSplitterWidth
//             // height: 250,
//             child: MWPGroupBox(
//                 'Командировка',
//                 // Container(
//                 // Ширина контейера для поля командировки
//                 // width: 800,
//                 // decoration: BoxDecoration(border: Border.all(width: 2)),
//                 // child:

//                 // Внимание
//                 // Возможная проблема левой части, что в роу колумн, в которой еще список роу
//                 // Внимание
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         MWPAttribute(
//                           'Вид командировки',
//                           this.card.isInternationalText,
//                           leftSplitterWidth: leftSplitterWidth,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         MWPAttribute(
//                           'Город',
//                           this.card.nCity,
//                           leftSplitterWidth: leftSplitterWidth,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         MWPAttribute(
//                           'Период',
//                           'с ' +
//                               this.card.begDTText +
//                               ' по ' +
//                               this.card.endDTText,
//                           leftSplitterWidth: leftSplitterWidth,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         MWPAttribute(
//                           'Продолжительность',
//                           this.card.calendarDaysText,
//                           leftSplitterWidth: leftSplitterWidth,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         MWPAttribute(
//                           'Вид транспорта',
//                           this.card.transportType,
//                           leftSplitterWidth: leftSplitterWidth,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   ],
//                   // ),
//                 )),
//           ),
//           MWPGroupBox(
//               'Цель',
//               Text(
//                 this.card.goalText,
//                 overflow: TextOverflow.visible,
//                 maxLines: 1,
//               )),
//           MWPGroupBox(
//               'Доп.информация',
//               Container(
//                 child: Text(
//                   this.card.addInfText,
//                   overflow: TextOverflow.visible,
//                   maxLines: 1,
//                 ),
//               )),
//           MWPGroupBox('Делегация', Container()),
//           MWPGroupBox('Резолюция', Container()),
//         ],
//       ),

//       // Column(
//       //   children: <Widget>[

//       //   ],
//       // ),
//     );
//   }
// }

// /// Список делегатов командировки
// class BTripDelegation extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// /// Элемент списка командировок
// class BTripListItem extends StatelessWidget {
//   final BTripCard _card;

//   final bool _isLight;
//   final bool _isSelected;

//   BTripListItem(this._card, this._isLight, this._isSelected);

//   @override
//   Widget build(BuildContext context) {
//     Color backColor;
//     if (_isSelected) {
//       backColor = mwpAccentColorLight;
//     } else {
//       if (_isLight)
//         backColor = new Color.fromARGB(255, 247, 247, 247);
//       else
//         backColor = new Color.fromARGB(255, 226, 226, 226);
//     }

//     return Container(
//       padding: EdgeInsets.only(right: 7, left: 7, top: 14, bottom: 14),
//       width: 100,
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey, width: 1.0), color: backColor),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                   height: 35,
//                   child: Text(
//                     _card.nCity,
//                     textAlign: TextAlign.left,
//                     style: TextStyle(fontSize: 25),
//                     overflow: TextOverflow.visible,
//                     maxLines: 1,
//                   ),
//                 ),
//               ),
//               // Expanded(
//               //   child: Container(),
//               // ),
//               Expanded(
//                 child: Container(
//                   height: 35,
//                   child: Text(
//                     _card.begDTText,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(fontSize: 25),
//                     overflow: TextOverflow.visible,
//                     maxLines: 1,
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               Expanded(
//                 child: Container(
//                   height: 35,
//                   child: Text(
//                     _card.countryText,
//                     textAlign: TextAlign.left,
//                     style: TextStyle(fontSize: 20),
//                     overflow: TextOverflow.visible,
//                     maxLines: 1,
//                   ),
//                 ),
//               ),
//               // Expanded(
//               //   child: Container(),
//               // ),
//               Expanded(
//                 child: Container(
//                   height: 35,
//                   child: Text(
//                     _card.calendarDaysText,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(fontSize: 20),
//                     overflow: TextOverflow.visible,
//                     maxLines: 1,
//                   ),
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
