import 'package:MWPX/views/rk_card/rk_dialogs/btrip_dialogs.dart';
import 'package:MWPX/views/rk_card/rk_dialogs/incoming_dialogs.dart';
import 'package:MWPX/views/rk_card/rk_dialogs/vacation_dialogs.dart';
import 'package:MWPX/widgets/button/rounded_button2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class RKSimpleLightLeftHeader extends StatefulWidget {
  // final bool? simple;
  final String? dokar;
  final List<DataGridCell<dynamic>>? cellsList;
  final double? leftSplitterWidth;
  final BuildContext? buildContext;

  RKSimpleLightLeftHeader({
    this.dokar = '',
    this.cellsList,
    this.leftSplitterWidth,
    this.buildContext,
    // this.simple = true,
  });

  @override
  _RKSimpleLightLeftHeaderState createState() =>
      _RKSimpleLightLeftHeaderState();
}

class _RKSimpleLightLeftHeaderState extends State<RKSimpleLightLeftHeader> {
  @override
  Widget build(BuildContext context) {
    Widget leftHeaderContent = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: RoundedButton2(
            onPressed: () {
              if (widget.dokar == 'LVE') {
                VacationDilogs.getVacationRKDialog(
                  context: widget.buildContext,
                  cellsList: widget.cellsList,
                );
              }
              if (widget.dokar == 'BTR') {
                BTripDilogs.getBTripRKDialog(
                  context: widget.buildContext,
                  cellsList: widget.cellsList,
                );
              }
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
      child: leftHeaderContent,
    );
  }
}
