import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/views/foldertileview.dart';
import 'controls/appbar.dart';

class ChangingMainView extends StatefulWidget {
  @override
  createState() {
    return new ChangingMainViewState();
  }
}

class ChangingMainViewState extends State<ChangingMainView> {
  int iCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MWPMainAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  setState(() {
                    iCount++;
                  });
                },
                child: Text('++'),
              ),
              Text('Кол-во: $iCount'),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      iCount--;
                    });
                  },
                  child: Text('--')),
            ],
          ),
        ));
  }
}

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: MWPFolderTileView()));
}
