import 'package:MWPX/services/biometric_service.dart';
import 'package:MWPX/services/data_grid_service.dart';
import 'package:MWPX/services/home_service.dart';
import 'package:MWPX/services/report_service.dart';
import 'package:MWPX/services/shared_prefers_service.dart';
import 'package:MWPX/views/home/home_body.dart';
import 'package:MWPX/views/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/biometrics/biometrics_screen.dart';

void main() {
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
        Provider<SharedPrefsService>(
          create: (_) => SharedPrefsService(),
        ),
        Provider<DataGridService>(
          create: (_) => DataGridService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MWPFolderTileViewScreen(),
        // home: BiometricsScreen(),
      ),
    ),
  );
}
