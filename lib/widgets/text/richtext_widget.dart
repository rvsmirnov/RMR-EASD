import 'package:MWPX/styles/mwp_colors.dart';
import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  final String? text;
  final String? boldText;
  final BuildContext? context;
  const RichTextWidget({
    this.text,
    this.boldText,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          color: MWPColors.mwpColorBlack,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
          ),
          TextSpan(
              text: boldText, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
