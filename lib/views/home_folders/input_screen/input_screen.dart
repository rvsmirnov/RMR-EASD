import 'package:MWPX/blocs/home/home_bloc.dart';
import 'package:MWPX/services/home_service.dart';
import 'package:MWPX/views/home/home_body.dart';
import 'package:MWPX/widgets/button/squarebutton.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Страница с плитками папок
class InputScreen extends StatefulWidget {
  final void Function(String)? onPressed;
  final String? textFieldContent;

  InputScreen({this.onPressed, this.textFieldContent});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.textFieldContent!;
  }

  Widget build(BuildContext context) {
    print('onPressed in InputScreen ${widget.onPressed}');
    MWPMainAppBar app_bar = MWPMainAppBar();
    MWPButtonBar button_bar = MWPButtonBar();

    app_bar.configureAppBar('Резолюция', false, true);
    button_bar.configureButtonBar(Constants.viewNameFolders);

    return Scaffold(
      appBar: app_bar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 250, 250, 250),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: TextField(
                  // autofocus: true,
                  // onChanged: (input) {
                  //   resolutionController.text = input;
                  // },
                  // onTap: () {print('onChanged');},
                  controller: controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // border: new OutlineInputBorder(
                    //     borderSide: new BorderSide(color: Colors.grey)),
                    contentPadding: EdgeInsets.fromLTRB(7, 0, 7, 3),
                  ),
                ),
              ),
            ),
          ),
          Align(
            child: Container(
                alignment: Alignment.center,
                height: 75,
                width: double.infinity,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MWPSquareButton(
                      'Сохранить',
                      onPressed: () {
                        widget.onPressed!(controller.text);
                      },
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
