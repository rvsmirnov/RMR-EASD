import 'package:MWPX/data_processing/dictionary/DocumentTypeOperator.dart';
import 'package:MWPX/data_structure/dictionary/DocumentTypeItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart' as xml;

///Класс для получения справочника типов документов
class DocumentTypeExporter extends CommonExporter {
  ///Конструктор, инициализация
  DocumentTypeExporter();

  //Установка параметров экспорта папок
  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <soapenv:Header/>
            <soapenv:Body>
                <urn:ZAWPWS03_EX_VIDDOC/>
            </soapenv:Body>
          </soapenv:Envelope>''';
  }

  @override
  Future<void> doExport(ConnectionConfig pConConf) async {
    //Запросим данные из ЕАСД
    await getRemoteResponse(
        pConConf.fullEasdURL, pConConf.encodedLoginPassword, envelop);

    //Получим список папок
    xml.XmlElement dictData =
        super.parsedXml.findAllElements('ET_DICT_DATA').single;

    await DocumentTypeOperator.clearAll();

    DocumentTypeItem dti = new DocumentTypeItem();
    dti.logSys = "DSD200";
    dti.sCode = "";
    dti.value = "";
    await DocumentTypeOperator.insert(dti);

    for (var item in dictData.children) {
      dti = new DocumentTypeItem();

      dti.logSys = "DSD200";
      dti.sCode = getItemValueByName(item, 'CODE');
      dti.value = getItemValueByName(item, 'VALUE');

      await DocumentTypeOperator.insert(dti);
    }
  }
}
