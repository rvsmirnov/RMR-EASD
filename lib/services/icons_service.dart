import 'package:flutter/material.dart';

class IconsService {
  static Widget getIconRK(String value) {
      if (value == 'VHD') {
        return Image.asset(
          'assets/images/dokar_icons/incoming.gif',
          width: 30,
          height: 30,
        );
      }
      if (value == 'ORD') {
        return Image.asset(
          'assets/images/dokar_icons/ord.gif',
          width: 30,
          height: 30,
        );
      }
      if (value == 'ДКИ') {
        return Image.asset(
          'assets/images/dokar_icons/instruction.gif',
          width: 30,
          height: 30,
        );
      }
      if (value == 'ISD') {
        return Image.asset(
          'assets/images/dokar_icons/outgoing.gif',
          width: 30,
          height: 30,
        );
      }
      return Image.asset(
        'assets/images/dokar_icons/incoming.gif',
        width: 30,
        height: 30,
      );
    }
}