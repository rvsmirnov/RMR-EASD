import 'dart:async';
import 'package:flutter/material.dart';

class CountUpTimer extends StatefulWidget {
  const CountUpTimer({Key? key}) : super(key: key);

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
          } else {
            seconds = seconds + 1;
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
