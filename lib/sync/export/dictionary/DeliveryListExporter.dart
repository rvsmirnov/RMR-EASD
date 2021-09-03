import 'package:MWPX/data_processing/dictionary/DeliveryListOperator.dart';
import 'package:MWPX/data_structure/dictionary/DeliveryListHeaderItem.dart';
import 'package:MWPX/data_structure/dictionary/DeliveryListMemberItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart' as xml;

class DeliveryListExporter extends CommonExporter {
  ///Конструктор, инициализация
  DeliveryListExporter();

  //Установка параметров экспорта типовых текстов
  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
              <soapenv:Header/>
              <soapenv:Body>
                  <urn:ZAWPWS03_EX_DELIV_LIST/>
              </soapenv:Body>
            </soapenv:Envelope>''';
  }

  @override
  Future<void> doExport(ConnectionConfig pConConf) async {
    //Запросим данные из ЕАСД
    await getRemoteResponse(
        pConConf.fullEasdURL, pConConf.encodedLoginPassword, envelop);

    //Получим список Заголовков списков рассылки
    xml.XmlElement headerData =
        super.parsedXml.findAllElements('ET_ALST_HEAD').single;

    xml.XmlElement memberData =
        super.parsedXml.findAllElements('ET_ALST_DATA').single;

    await DeliveryListOperator.clearAll();

    for (var header in headerData.children) {
      DeliveryListHeaderItem dlh = new DeliveryListHeaderItem();

      dlh.logSys = "DSD200";
      dlh.sCode = getItemValueByName(header, 'ALSTID');
      dlh.headerText = getItemValueByName(header, 'ALST_TEXT');

      await DeliveryListOperator.insertHeader(dlh);

      for (var member in memberData.children) {
        String listCode = getItemValueByName(member, 'ALSTID');
        if (listCode == dlh.sCode) {
          DeliveryListMemberItem dlm = new DeliveryListMemberItem();

          dlm.logSys = dlh.logSys;
          dlm.listCode = dlh.sCode;
          dlm.recnr = getItemValueByName(member, 'RECNR');
          dlm.personCode = getItemValueByName(member, 'OTYPE') +
              ' ' +
              getItemValueByName(member, 'OBJID');

          await DeliveryListOperator.insertMember(dlm);
        }
      }
    }
  }
}
