import 'dart:async';
import 'package:flutter/material.dart';

class CountUpTimer extends StatefulWidget {
  final int? timerLimit;
  final Function? callbackAction;
  const CountUpTimer({
    this.timerLimit,
    this.callbackAction,
  });

  @override
  State<CountUpTimer> createState() => _CountUpTimerState();
}

class _CountUpTimerState extends State<CountUpTimer> {
  Timer? _timer;
  int seconds = 0;
  // int minutes = 0;
  // int hours = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else if (seconds == widget.timerLimit!-1) {
            // print('seconds in seconds == widget.timerLimit $seconds ');
            timer.cancel();
            widget.callbackAction!();
          } else {
            // print('seconds in else 1 $seconds ');
            seconds = seconds + 1;
            // print('seconds in else 2 $seconds ');
            // if (seconds > 59) {
            //   minutes += 1;
            //   seconds = 0;
            //   if (minutes > 59) {
            //     hours += 1;
            //     minutes = 0;
            //   }
            // }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '$seconds сек.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
