import 'package:MWPX/blocs/home/home_bloc.dart';
import 'package:MWPX/services/home_service.dart';
import 'package:MWPX/views/home/home_body.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Страница с плитками папок
class MWPFolderTileViewScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    MWPMainAppBar app_bar = MWPMainAppBar();
    HomeService homeService = Provider.of<HomeService>(context);

    app_bar.configureAppBar('Рабочее Место Руководителя', true, false);

    return Scaffold(
      appBar: app_bar,
      body: BlocProvider(
        create: (BuildContext context) => HomeBloc(
          homeService: homeService,
        )..add(OpenScreen()),
        child: MWPFolderTileView(),
      ),
    );
  }
}
