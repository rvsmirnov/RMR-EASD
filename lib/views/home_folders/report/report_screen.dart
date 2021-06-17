import 'package:MWPX/blocs/home_folders/report/report_bloc.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/views/home_folders/report/report_body.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Страница с плитками папок
class ReportScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    MWPMainAppBar app_bar = MWPMainAppBar();
    ReportService reportService = Provider.of<ReportService>(context);

    app_bar.configureAppBar('Мобильное рабочее место ЕАСД', true, true);

    return Scaffold(
      appBar: app_bar,
      body: BlocProvider(
        create: (BuildContext context) => ReportBloc(
          reportService: reportService,
        )..add(OpenScreen()),
        child: ReportBody(),
      ),
    );
  }
}