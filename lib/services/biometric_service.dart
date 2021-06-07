import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

final LocalAuthentication biometricsAuth = LocalAuthentication();

class BiometricService {

  // Чтобы проверить, доступна ли на этом устройстве локальная аутентификация
  Future<bool> checkingBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await biometricsAuth.canCheckBiometrics;
      // print('canCheckBiometrics $canCheckBiometrics');
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
    // if (!mounted) return;
    return canCheckBiometrics;
  }

  // Чтобы получить список зарегистрированных биометрических данных,
  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> listBiometrics = new List<BiometricType>.empty();
    try {
      listBiometrics = await biometricsAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    // if (!mounted) return;
    return listBiometrics;
  }

  // Непосредственная процедура авторизации
  Future<bool> authenticationWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await biometricsAuth.authenticate(
          localizedReason: 'Просканируйте свой палец для аутентификации',
          useErrorDialogs: true,
          stickyAuth: true);
    } on PlatformException catch (e) {
      print('error in biometricsAuthenticate $e');
    }
    // if (!mounted) return;
    return authenticated;
  }

}