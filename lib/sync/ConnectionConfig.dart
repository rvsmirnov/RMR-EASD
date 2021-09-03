import 'dart:convert';

///Класс для хранения свойств подключения к сервереру ЕАСД
class ConnectionConfig {
  ///Название синхронизируемой системы
  String systemName = "DSD";

  //Является система домашней(основной)
  bool isSystemNative = false;

  ///Имя ли адрес сервера ЕАСД
  String hostName = '10.248.14.73:8001';

  ///строка пути до вызываемой службы
  String addressString =
      '/sap/bc/srt/rfc/sap/z_awp_0_3/200/z_awp_0_3/z_awp_0_3';
  //'/sap/bc/srt/rfc/sap/z_awp_0_2/200/z_awp_0_2/z_awp_0_2';

  /// Полное имя вызываемой службы
  String get fullEasdURL {
    return 'http://$hostName$addressString';
  }

  ///Логин пользователя
  String userLogin = '';

  ///Пароль пользователя
  String userPassword = '';

  /// Base64-кодированная строка с данными аутентификации на сервере ЕАСД
  String get encodedLoginPassword {
    String logpass = '$userLogin:$userPassword';

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(logpass);

    return encoded;
  }
}
