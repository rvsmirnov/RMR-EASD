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
      return Image.asset(
        'assets/images/dokar_icons/incoming.gif',
        width: 30,
        height: 30,
      );
    }
}