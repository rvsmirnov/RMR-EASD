import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Nav(
              child: Left(),
            ),
          ),
          Expanded(
            child: Nav(
              child: Right(),
            ),
          ),
        ],
      ),
    );
  }
}

class Left extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => AlertDialog(
            content: Text('Dialog'),
          ),
        ),
        child: Text('SHOW'),
      ),
    );
  }
}

class Right extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Hi'),
    );
  }
}

class Nav extends StatelessWidget {
  final Widget child;

  Nav({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => child,
      ),
    );
  }
}
