import 'package:flutter/material.dart';

/// Квадратная кнопка с округленными краями
class RoundedButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;

  RoundedButton({this.child, this.onPressed});

  Widget build(BuildContext context) {
    return Container(
      width: 30,
      // margin: EdgeInsets.all(7),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          side: BorderSide(width: 1, color: Colors.black),
        ),
        // ButtonStyle(
        //   shape: MaterialStateProperty.all(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(7.0),
        //     ),
        //   ),
        // ),
        // borderSide: BorderSide(
        //   color: Colors.white,
        // ),
        // shape: new RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(7.0),
        // ),
        //splashColor: Colors.lightGreen,
        // highlightedBorderColor: Colors.green,
        onPressed: onPressed,
        child: child!,
      ),
    );
  }
}
