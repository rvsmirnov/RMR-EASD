import 'package:flutter/material.dart';
// import 'package:MWPX/mwp_colors.dart' as mwpColors;

class MWPElevatedButton extends ElevatedButton {
  // final Color? primaryColor;

  MWPElevatedButton({
    onPressed,
    child,
    style,
    // this.primaryColor = mwpColors.mwpAccentColor,
  }) : super(
          onPressed: onPressed,
          child: child,
          style: style,
        );

  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: child,
    );
  }
}
