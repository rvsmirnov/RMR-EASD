import 'package:flutter/material.dart';

class ContainerTextCell extends StatelessWidget {
  final String? textValue;
  final Color? color;

  const ContainerTextCell({this.textValue, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      color: color,
      child: Text(
        textValue!,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
