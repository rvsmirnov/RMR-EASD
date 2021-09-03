import 'package:MWPX/data_structure/card/body/incoming/IncomingCard.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/longtext/LongTextAssistant.dart';
import 'package:xml/xml.dart' as xml;

class IncomingExporter extends CommonCardExporter {
  ///Список сконвертированных РК, полученных из ЕАСД
  List<IncomingCard> convertedCardList = [];

  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZAWPWS03_EX_CARD_010004>
         <IT_LOAD_LIST>
            ${super.loadListXML}
         </IT_LOAD_LIST>         
          <!--Optional:-->
         <I_EXPORT_FILE_LIST>X</I_EXPORT_FILE_LIST>
         <!--Optional:-->
         <I_FILTER_FILE_LIST>X</I_FILTER_FILE_LIST>
         <!--Optional:-->
         <I_FILTER_MODE>1</I_FILTER_MODE>
         <I_NEED_LOCK>X</I_NEED_LOCK>

      </urn:ZAWPWS03_EX_CARD_010004>
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

    xml.XmlElement fileTableData =
        super.parsedXml.findAllElements('ET_FILE_RECORD').single;

    xml.XmlElement fileTableSignerData =
        super.parsedXml.findAllElements('ET_RECORD_STAMP_SIGNER').single;

    xml.XmlElement iterationTableData =
        super.parsedXml.findAllElements('ET_MSTI_DATA').single;
    xml.XmlElement iterationTableNoteData =
        super.parsedXml.findAllElements('ET_MSTI_COMM_DATA').single;

    xml.XmlElement longTextTableData =
        super.parsedXml.findAllElements('ET_TEXT_DATA').single;

    LongTextAssistant lta = new LongTextAssistant();

    lta.importFromSAPTable(longTextTableData);

    for (var xmlCard in cardData.children) {
      IncomingCard incCard = new IncomingCard();
      incCard.logsys = getItemValueByName(xmlCard, "LOGSYS");
      incCard.dokar = getItemValueByName(xmlCard, "DOKAR");
      incCard.doknr = getItemValueByName(xmlCard, "DOKNR");
      incCard.dokvr = getItemValueByName(xmlCard, "DOKVR");
      incCard.doktl = getItemValueByName(xmlCard, "DOKTL");
      incCard.doknrTRUNC = getItemValueByName(xmlCard, "DOKNR_TRUNC");

      incCard.createdDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CREATED_ON"),
          getItemValueByName(xmlCard, "CREATED_TM"));
      incCard.changedDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CHANGED_ON"),
          getItemValueByName(xmlCard, "CHANGED_TM"));

      if (incCard.changedDT.year == 1900) {
        incCard.changedDT = incCard.createdDT;
      }

      incCard.regNum = SapTypeHelper.regNumToString(
          getItemValueByName(xmlCard, "PRECODE"),
          getItemValueByName(xmlCard, "REGNUM"),
          getItemValueByName(xmlCard, "CODE"));

      incCard.regDate = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "REGDATE"), "00:00:00");

      incCard.documentType = getItemValueByName(xmlCard, "VIDDOC");

      incCard.content = lta.getTextString(incCard.dokar, incCard.doknr,
          incCard.dokvr, incCard.doktl, "DOCTEXT");

      incCard.mainAuthor = getItemValueByName(xmlCard, "MK_FIO_TEXT");
      incCard.mainAuthorOrg = getItemValueByName(xmlCard, "MK_ORG_TEXT");

      // Поле "Важность"
      incCard.cardUrgent =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "CHB_V"))
              ? 1
              : 0;

      //Сконвертируем таблицу согласования
      incCard.routeTable =
          convertRouteTable(incCard, routeTableData, routeTableNoteData);

      incCard.fileTable =
          convertFileTable(incCard, fileTableData, fileTableSignerData);

      //Сконвертируем таблицу итераций Рук-Пом
      incCard.iterationTable = convertIterationTable(
          incCard, iterationTableData, iterationTableNoteData);

      //Добавим РК Командировки в набор сконвертированных
      convertedCardList.add(incCard);
    }
  }
}
