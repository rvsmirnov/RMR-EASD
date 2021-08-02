import 'package:MWPX/views/rk_card/rk_dialogs/incoming_dialogs.dart';
import 'package:MWPX/widgets/button/rounded_button2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RKSimpleLeftHeader extends StatefulWidget {
  // final bool? simple;
  final List<DataGridCell<dynamic>>? cellsList;
  final double? leftSplitterWidth;
  final BuildContext? buildContext;
  final Function? onAllCheckBoxSelected;

  RKSimpleLeftHeader({
    this.cellsList,
    this.leftSplitterWidth,
    this.buildContext,
    this.onAllCheckBoxSelected,
    // this.simple = true,
  });

  @override
  _RKSimpleLeftHeaderState createState() => _RKSimpleLeftHeaderState();
}

class _RKSimpleLeftHeaderState extends State<RKSimpleLeftHeader> {
  bool checkedValue = false;
  bool meetingCheckedValue = false;

  @override
  Widget build(BuildContext context) {
    Widget leftHeaderContent = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Checkbox(
          value: meetingCheckedValue,
          onChanged: (bool? newValue) {
            setState(() {
              meetingCheckedValue = newValue!;
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
              IncomingDilogs.getIncomingRKDialog(
                context: widget.buildContext,
                cellsList: widget.cellsList,
              );
            },
            child: Center(
              child: Container(
                height: 20,
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
      ],
    );

    return Container(
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
                        widget.onAllCheckBoxSelected!(newValue);
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
          widget.leftSplitterWidth! < 0.3
              ? Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: leftHeaderContent),
                )
              : leftHeaderContent
        ],
      ),
    );
  }
}
