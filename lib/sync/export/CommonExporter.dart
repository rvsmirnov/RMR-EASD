import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

///Класс-родитель для классов получения данных из ЕАСД
class CommonExporter {
  ///Строка вызова нужного метода из общего сервиса. В потомках переопределяем это свойство
  String envelop = '';

  /// ответ от сервера ЕАСД в виде XML
  xml.XmlDocument _parsedXml = xml.XmlDocument.parse("<xml/>");

  xml.XmlDocument get parsedXml {
    return _parsedXml;
  }

  /// Получить значение поля по его названию. Нужно для конвертации данных из XML
  String getItemValueByName(xml.XmlNode item, String name) {
    var itemElement = item.getElement(name);
    if (itemElement != null)
      return itemElement.innerText;
    else
      return '';
  }

  ///Получение данных из ЕАСД в виде документа XML
  Future<void> getRemoteResponse(
      String pServiceAddress, String pLogPassEncoded, String pEnvelop) async {
    var uri = Uri.parse(pServiceAddress);
    try {
      http.Response response = await http.post(uri,
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'Authorization': 'Basic $pLogPassEncoded'
          },
          body: pEnvelop);

      _parsedXml = xml.XmlDocument.parse(response.body);
    } catch (e) {
      _parsedXml = xml.XmlDocument.parse("");
    }
  }

  /// Получение и конвертация данных, полученных из ЕАСД. Этот метод переопределяем в потомках
  Future<void> doExport(ConnectionConfig pConConf) async {}
}
