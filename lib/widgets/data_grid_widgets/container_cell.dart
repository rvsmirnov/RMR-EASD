import 'package:MWPX/views/home_folders/decision/decision_card/decision_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ContainerCell extends StatelessWidget {
  final Widget? childWidget;
  final List<DataGridCell<dynamic>>? cellsList;
  final String routeTypeCard;
  const ContainerCell({this.childWidget, this.cellsList, this.routeTypeCard = ''});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return InkWell(
        onTap: () {
          if (routeTypeCard == 'decision') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DecisionCard(
                  cellsList: cellsList,
                ),
              ),
            );
          }
          if (routeTypeCard == 'agreement') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AgreementCard(
            //       cellsList: cellsList,
            //     ),
            //   ),
            // );
          }
          if (routeTypeCard == 'execution') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ExecutionCard(
            //       cellsList: cellsList,
            //     ),
            //   ),
            // );
          }
          if (routeTypeCard == 'sign') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => SignCard(
            //       cellsList: cellsList,
            //     ),
            //   ),
            // );
          }
          if (routeTypeCard == 'control') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ControlCard(
            //       cellsList: cellsList,
            //     ),
            //   ),
            // );
          }
          if (routeTypeCard == 'acquaintance') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AcquaintanceCard(
            //       cellsList: cellsList,
            //     ),
            //   ),
            // );
          }
        },
        child: childWidget!,
      );
    });
  }
}
