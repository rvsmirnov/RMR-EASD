import 'package:MWPX/views/rk_card/rk_dialogs/ORD_dialogs.dart';
import 'package:MWPX/views/rk_card/rk_dialogs/instruction_dialogs.dart';
import 'package:MWPX/views/rk_card/rk_dialogs/outgoing_dialogs.dart';
import 'package:MWPX/widgets/button/rounded_button2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RKLeftHeader extends StatefulWidget {
  // final bool? simple;
  final String? dokar;
  final List<DataGridCell<dynamic>>? cellsList;
  final String? rightButtonText;
  final double? leftSplitterWidth;

  RKLeftHeader({
    this.dokar = '',
    this.cellsList = const <DataGridCell<dynamic>>[],
    this.leftSplitterWidth,
    this.rightButtonText = 'Лист согласования',
    // this.simple = true,
  });

  @override
  _RKLeftHeaderState createState() => _RKLeftHeaderState();
}

class _RKLeftHeaderState extends State<RKLeftHeader> {
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
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
              if (widget.dokar == 'ORD') {
                ORDDilogs.getORDRKDialog(
                  context: context,
                  cellsList: widget.cellsList,
                );
              }
              if (widget.dokar == 'ISD') {
                OutgoingDilogs.getOutgoingRKDialog(
                  context: context,
                  cellsList: widget.cellsList,
                );
              }
              if (widget.dokar == 'ДКИ') {
                InstructionDilogs.getInstructionRKDialog(
                  context: context,
                  cellsList: widget.cellsList,
                );
              }
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
                      if (widget.dokar == 'ORD') {
                        ORDDilogs.getORDAgreementDialog(
                          context: context,
                        );
                      }
                      if (widget.dokar == 'ISD') {
                        OutgoingDilogs.getOutgoingAgreementDialog(
                          context: context,
                        );
                      }
                      if (widget.dokar == 'ДКИ') {
                        InstructionDilogs.getInstructionAgreementDialog(
                          context: context,
                        );
                      }
                    },
                    // width: 360*widget.leftSplitterWidth!,
                    width: 160,
                    height: 40,
                    child: Center(
                      child: Container(
                        // height: 20,
                        child: Text(
                          widget.rightButtonText!,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: RoundedButton2(
                      onPressed: () {},
                      child: Icon(
                        Icons.content_copy,
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
    );
  }
}
