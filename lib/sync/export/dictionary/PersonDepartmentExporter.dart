import 'package:MWPX/data_processing/dictionary/PersonDepartmentOperator.dart';
import 'package:MWPX/data_structure/dictionary/PersonDepartmentItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart' as xml;

/// Класс для получения данных о сотрудниках и подразделениях
class PersonDepartmentExporter extends CommonExporter {
  ///Конструктор, инициализация
  PersonDepartmentExporter();

  //Установка параметров экспорта типовых текстов
  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZAWPWS03_EX_PERS_SUBLIST>
         <!--Optional:-->
         <I_APPEND_MY_PODR></I_APPEND_MY_PODR>
      </urn:ZAWPWS03_EX_PERS_SUBLIST>
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
        super.parsedXml.findAllElements('ET_PERS_ENTRY').single;

    await PersonDepartmentOperator.clearAll();

    for (var item in dictData.children) {
      PersonDepartmentItem pdi = new PersonDepartmentItem();

      pdi.logSys = "DSD200";
      pdi.personCode = getItemValueByName(item, 'PERSON');
      pdi.departmentCode = getItemValueByName(item, 'PODR');
      pdi.positionCode = getItemValueByName(item, 'POST');
      pdi.personText = getItemValueByName(item, 'PERSON_TEXT');
      pdi.departmentText = getItemValueByName(item, 'PODR_TEXT');
      pdi.positionText = getItemValueByName(item, 'POST_TEXT');

      await PersonDepartmentOperator.insert(pdi);
    }
  }
}
