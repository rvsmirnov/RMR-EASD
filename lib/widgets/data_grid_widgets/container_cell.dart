import 'package:MWPX/views/rk_card/rk_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ContainerCell extends StatelessWidget {
  final Widget? childWidget;
  final List<DataGridCell<dynamic>>? cellsList;
  final String routeTypeCard;
  final String? dokar;
  const ContainerCell({
    this.childWidget,
    this.cellsList,
    this.routeTypeCard = '',
    this.dokar = '',
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return InkWell(
        onTap: () {
          if (routeTypeCard == 'decision') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RKCard(
                  cellsList: cellsList,
                  cardTitle: 'На решение',
                  dokar: dokar,
                ),
              ),
            );
          }
          if (routeTypeCard == 'agreement') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RKCard(
                  cellsList: cellsList,
                  cardTitle: 'На согласование',
                  dokar: dokar,
                ),
              ),
            );
          }
          if (routeTypeCard == 'execution') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RKCard(
                  cellsList: cellsList,
                  cardTitle: 'На исполнение',
                  dokar: dokar,
                ),
              ),
            );
          }
          if (routeTypeCard == 'sign') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RKCard(
                  cellsList: cellsList,
                  cardTitle: 'На подписание',
                  dokar: dokar,
                ),
              ),
            );
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
