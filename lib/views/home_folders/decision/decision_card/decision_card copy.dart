import 'package:MWPX/data_structure/card/body/btrip/BTripCard.dart';
import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';
import 'package:MWPX/views/home_folders/input_screen/input_screen.dart';
import 'package:MWPX/widgets/MWPGroupsBox.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button/circlebutton.dart';
import 'package:MWPX/widgets/button/rounded_button.dart';
import 'package:MWPX/widgets/button/rounded_button2.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/MWPAttribute.dart';
import 'package:MWPX/widgets/MWPGroupBox.dart';
import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:split_view/split_view.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/constants.dart' as Constants;

class DecisionCard extends StatefulWidget {
  @override
  _DecisionCardState createState() => _DecisionCardState();
}

class _DecisionCardState extends State<DecisionCard> {
  int _selectedIndex = 0;
  IncomingCard _selectedCard = new IncomingCard();
  double rightSplitterWidth = 0.5;
  double leftSplitterWidth = 0.5;

  Widget build(BuildContext context) {
    var appBar = new MWPMainAppBar();
    appBar.configureAppBar('На решение', false, true);

    var buttonBar = new MWPButtonBar();
    buttonBar.configureButtonBar(Constants.viewNameBTrips);

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
  }

  _selectItem(int i) {
    print("Selected $i row");
    _selectedIndex = i;
    setState(() {});
  }
}

class LeftCardView extends StatefulWidget {
  final IncomingCard card;
  final double? leftSplitterWidth;

  LeftCardView(this.card, {this.leftSplitterWidth});

  @override
  State<LeftCardView> createState() => _LeftCardViewState();
}

class _LeftCardViewState extends State<LeftCardView> {
  bool checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 57,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
              ),
              // color: Colors.black,
            ),
            child: Row(
              children: [
                // Row(children: []),
                // Row(children: []),
                Flexible(
                  flex: 1,
                  // height: 40,
                  // width: 40,
                  child: CheckboxListTile(
                    // title: Text("title text"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    },
                    // controlAffinity:
                    //     ListTileControlAffinity.leading,
                  ),
                ),

                Flexible(
                  flex: 1,
                  child: RoundedButton2(
                    onPressed: () {},
                    child: Icon(
                      Icons.insert_drive_file,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
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
                ),

                // Flexible(
                //   flex: 2,
                //   child: Container(),
                // ),
                // Expanded(child: Container()),
                Flexible(
                  flex: 1,
                  // height: 40,
                  // width: 40,
                  child: CheckboxListTile(
                    // title: Text("title text"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue!;
                      });
                    },
                    // controlAffinity:
                    //     ListTileControlAffinity.leading,
                  ),
                ),
                Container(),
                Flexible(
                  flex: 2,
                  child: Text(
                    'К совещанию',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: RoundedButton2(
                      onPressed: () {},
                      child: Icon(
                        Icons.insert_drive_file,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Widget build(BuildContext context) {
    double minWeightLimit = getWeightLimit(MediaQuery.of(context).size.height);

    // Контент Проект резолюции
    Widget resolutionProjectContent = Container(
      child: Text(
        'Список коментариев: iterationTable',
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
          MWPGroupBox(
            'Проект резолюции',
            resolutionProjectContent,
            contentWidgetForDialog: resolutionProjectContent,
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
