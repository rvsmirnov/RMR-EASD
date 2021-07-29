import 'package:MWPX/blocs/biometric/biometric_bloc.dart';
import 'package:MWPX/styles/mwp_text_styles.dart';
import 'package:MWPX/views/home/home_screen.dart';
import 'package:MWPX/widgets/button/elevated_button.dart';
import 'package:MWPX/widgets/dialog_widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MWPX/styles/mwp_colors.dart';

class BiometricsBody extends StatefulWidget {
  @override
  _BiometricsBodyState createState() => _BiometricsBodyState();
}

class _BiometricsBodyState extends State<BiometricsBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BiometricBloc>(context).add(
      OpenScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BiometricBloc, BiometricState>(
      listener: (context, state) {
        if (state is BiometricSucess)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MWPFolderTileViewScreen(),
            ),
          );

        if (state is BiometricFailure) {
          BlocProvider.of<BiometricBloc>(context).add(
            OpenScreen(),
          );
          Dialogs.errorDialog(
            context: context,
            content: Text('${state.error}'),
          );
        }
      },
      builder: (context, state) {
        // print('state in biometrics body $state');
        if (state is BiometricLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is BiometricAvailable) {
          return Center(
            child: MWPElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: MwpTextStyles.buttonTextStyle,
                primary: MWPColors.mwpAccentColor,
              ),
              onPressed: () {
                BlocProvider.of<BiometricBloc>(context).add(
                  BiometricRun(),
                );
              },
              child: const Text('Войти по биометрии'),
            ),
          );
        }
        if (state is BiometricNotAvailable) {
          return Center(
            child: Text('Вход по биометрии не доступен на устройстве!'),
          );
        }
        return Container();
      },
    );
  }
}
