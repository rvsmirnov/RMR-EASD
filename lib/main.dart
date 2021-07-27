import 'package:MWPX/data_processing/DB.dart';
import 'package:MWPX/data_processing/folder/FolderOperator.dart';
import 'package:MWPX/services/biometric_service.dart';
import 'package:MWPX/services/home_service.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/views/home/home_body.dart';
import 'package:MWPX/views/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/biometrics/biometrics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();

  await FolderOperator.fillInitialFolders();

  runApp(
    MultiProvider(
      providers: [
        Provider<BiometricService>(
          create: (_) => BiometricService(),
        ),
        Provider<HomeService>(
          create: (_) => HomeService(),
        ),
        Provider<ReportService>(
          create: (_) => ReportService(),
        ),
        // ReportService
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MWPFolderTileViewScreen(),
        // home: BiometricsScreen(),
      ),
    ),
  );
}
