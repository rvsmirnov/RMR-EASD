import 'package:MWPX/data_processing/dictionary/TextTemplateOperator.dart';
import 'package:MWPX/data_structure/dictionary/TextTemplateItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart' as xml;

//Класс для получения данных стъправочника Типовых текстов из ЕАСД
class TextTemplateExporter extends CommonExporter {
  ///Конструктор, инициализация
  TextTemplateExporter();

  //Установка параметров экспорта типовых текстов
  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZAWPWS03_EX_TEXT_TEMPLATE/>
   </soapenv:Body>
</soapenv:Envelope>''';
  }

  @override
  Future<void> doExport(ConnectionConfig pConConf) async {
    //Запросим данные из ЕАСД
    await getRemoteResponse(
        pConConf.fullEasdURL, pConConf.encodedLoginPassword, envelop);

    //Получим список текстов
    xml.XmlElement dictData =
        super.parsedXml.findAllElements('ET_TEXT_DATA').single;

    await TextTemplateOperator.clearAll();

    for (var item in dictData.children) {
      TextTemplateItem tti = new TextTemplateItem();

      tti.logSys = "DSD200";
      tti.cardType = getItemValueByName(item, 'CARDNUM');
      tti.textType = getItemValueByName(item, 'STDTXT');
      tti.textValue = getItemValueByName(item, 'TEXT');

      await TextTemplateOperator.insert(tti);
    }
  }
}
