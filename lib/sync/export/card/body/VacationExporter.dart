import 'package:MWPX/data_structure/card/body/vacation/VacationCard.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/longtext/LongTextAssistant.dart';
import 'package:xml/xml.dart' as xml;

class VacationExporter extends CommonCardExporter {
  ///Список сконвертированных РК, полученных из ЕАСД
  List<VacationCard> convertedCardList = [];

  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZAWPWS03_EX_CARD_010008>
         <IT_LOAD_LIST>
            ${super.loadListXML}
         </IT_LOAD_LIST>         
         <I_NEED_LOCK>X</I_NEED_LOCK>
      </urn:ZAWPWS03_EX_CARD_010008>
   </soapenv:Body>
</soapenv:Envelope>''';
  }

  @override
  Future<void> doExport(ConnectionConfig pConConf) async {
    await getRemoteResponse(
        pConConf.fullEasdURL, pConConf.encodedLoginPassword, envelop);

    //Получим блоки данных РК
    xml.XmlElement cardData =
        super.parsedXml.findAllElements('ET_CARD_DATA').single;

    xml.XmlElement routeTableData =
        super.parsedXml.findAllElements('ET_APPR_DATA').single;
    xml.XmlElement routeTableNoteData =
        super.parsedXml.findAllElements('ET_ROUTE_NOTE').single;

    xml.XmlElement iterationTableData =
        super.parsedXml.findAllElements('ET_MSTI_DATA').single;
    xml.XmlElement iterationTableNoteData =
        super.parsedXml.findAllElements('ET_MSTI_COMM_DATA').single;

    xml.XmlElement longTextTableData =
        super.parsedXml.findAllElements('ET_TEXT_DATA').single;

    LongTextAssistant lta = new LongTextAssistant();

    lta.importFromSAPTable(longTextTableData);

    for (var xmlCard in cardData.children) {
      VacationCard vacCard = new VacationCard();
      vacCard.logsys = getItemValueByName(xmlCard, "LOGSYS");
      vacCard.dokar = getItemValueByName(xmlCard, "DOKAR");
      vacCard.doknr = getItemValueByName(xmlCard, "DOKNR");
      vacCard.dokvr = getItemValueByName(xmlCard, "DOKVR");
      vacCard.doktl = getItemValueByName(xmlCard, "DOKTL");

      vacCard.doknrTRUNC = getItemValueByName(xmlCard, "DOKNR_TRUNC");

      vacCard.createdDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CREATED_ON"),
          getItemValueByName(xmlCard, "CREATED_TM"));
      vacCard.changedDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CHANGED_ON"),
          getItemValueByName(xmlCard, "CHANGED_TM"));

      if (vacCard.changedDT.year == 1900) {
        vacCard.changedDT = vacCard.createdDT;
      }

      vacCard.documentType = "";

      vacCard.begDA = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "BEGDA"), "00:00:00");
      vacCard.endDA = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "ENDDA"), "00:00:00");
      vacCard.calendarDays =
          int.parse(getItemValueByName(xmlCard, "CALENDDAYS"));
      vacCard.intnlFlag = getItemValueByName(xmlCard, "INTNL");
      vacCard.location = getItemValueByName(xmlCard, "LOCATION");
      vacCard.unpaidFlag =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "UNPAID"));
      vacCard.emplName = getItemValueByName(xmlCard, "HROBJID_4_TEXT");
      vacCard.substName = getItemValueByName(xmlCard, "HROBJID_6_TEXT");

      vacCard.addInfText = lta.getTextString(vacCard.dokar, vacCard.doknr,
          vacCard.dokvr, vacCard.doktl, "DOCCOMMENT");

      vacCard.emplPodr = getItemValueByName(xmlCard, "HROBJID_3_TEXT");
      vacCard.emplState = getItemValueByName(xmlCard, "HROBJID_11_TEXT");

      vacCard.signerName = getItemValueByName(xmlCard, "HROBJID_10_TEXT");
      vacCard.signerDepartment = getItemValueByName(xmlCard, "HROBJID_9_TEXT");

      vacCard.content =
          "${vacCard.emplName}, ${vacCard.vacationPeriodText} , ${vacCard.location}";

      //Сконвертируем таблицу согласования
      vacCard.routeTable =
          convertRouteTable(vacCard, routeTableData, routeTableNoteData);

      //Сконвертируем таблицу итераций Рук-Пом
      vacCard.iterationTable = convertIterationTable(
          vacCard, iterationTableData, iterationTableNoteData);

      //Добавим РК Командировки в набор сконвертированных
      convertedCardList.add(vacCard);
    }
  }
}
