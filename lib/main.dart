import 'package:MWPX/services/biometric_service.dart';
import 'package:MWPX/views/home/home.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: MWPFolderTileView(),
        home: BiometricsScreen(),
      ),
    ),
  );
}
