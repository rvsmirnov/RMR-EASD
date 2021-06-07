import 'package:MWPX/blocs/biometric/biometric_bloc.dart';
import 'package:MWPX/services/biometric_service.dart';
import 'package:MWPX/views/biometrics/biometrics_body.dart';
import 'package:flutter/material.dart';
import 'package:MWPX/widgets/app_bar/appbar.dart';
import 'package:MWPX/widgets/button_bar/buttonbar.dart';
import 'package:MWPX/constants.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BiometricsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    MWPMainAppBar app_bar = MWPMainAppBar();
    MWPButtonBar button_bar = MWPButtonBar();
    BiometricService biometricService = Provider.of<BiometricService>(context);

    app_bar.configureAppBar('Вход в приложение', false, false);

    button_bar.configureButtonBar(Constants.viewNameFolders);

    return Scaffold(
      appBar: app_bar,
      body: BlocProvider(
        create: (BuildContext context) => BiometricBloc(
          biometricService: biometricService,
        ),
        child: BiometricsBody(),
      ),
    );
  }
}
