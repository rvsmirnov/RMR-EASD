import 'dart:async';
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final Duration? duration;
  const CountDownTimer({
    this.duration,
  });

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  Timer? _timer;
  int seconds = 0;

  @override
  void didChangeDependencies() {
    print('--1 seconds in CountDownTimer $seconds');
    super.didChangeDependencies();
    setState(() {
      seconds = widget.duration!.inSeconds;
    });
    print('-- widget.duration!.inSeconds ${widget.duration!.inSeconds}');
    print('--2 seconds in CountDownTimer $seconds');
  }

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
          if (seconds == 0) {
            timer.cancel();
          } else {
            seconds = seconds - 1;
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
