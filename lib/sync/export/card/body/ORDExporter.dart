import 'package:MWPX/data_structure/card/body/ord/ORDCard.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/longtext/LongTextAssistant.dart';
import 'package:xml/xml.dart' as xml;

class ORDExporter extends CommonCardExporter {
  ///Список сконвертированных РК, полученных из ЕАСД
  List<ORDCard> convertedCardList = [];

  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <soapenv:Header/>
            <soapenv:Body>
                <urn:ZAWPWS03_EX_CARD_010001>
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

                </urn:ZAWPWS03_EX_CARD_010001>
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
      ORDCard ordCard = new ORDCard();
      ordCard.logsys = getItemValueByName(xmlCard, "LOGSYS");
      ordCard.dokar = getItemValueByName(xmlCard, "DOKAR");
      ordCard.doknr = getItemValueByName(xmlCard, "DOKNR");
      ordCard.dokvr = getItemValueByName(xmlCard, "DOKVR");
      ordCard.doktl = getItemValueByName(xmlCard, "DOKTL");
      ordCard.doknrTRUNC = getItemValueByName(xmlCard, "DOKNR_TRUNC");

      ordCard.createdDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CREATED_ON"),
          getItemValueByName(xmlCard, "CREATED_TM"));
      ordCard.changedDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CHANGED_ON"),
          getItemValueByName(xmlCard, "CHANGED_TM"));

      if (ordCard.changedDT.year == 1900) {
        ordCard.changedDT = ordCard.createdDT;
      }

      ordCard.regNum = SapTypeHelper.regNumToString(
          getItemValueByName(xmlCard, "PRECODE"),
          getItemValueByName(xmlCard, "REGNUM"),
          getItemValueByName(xmlCard, "CODE"));

      ordCard.regDate = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "REGDATE"), "00:00:00");

      ordCard.documentType = getItemValueByName(xmlCard, "VIDDOC");

      ordCard.content = lta.getTextString(ordCard.dokar, ordCard.doknr,
          ordCard.dokvr, ordCard.doktl, "DOCTEXT");

      ordCard.executorOrg = getItemValueByName(xmlCard, "HROBJID_4_TEXT");
      ordCard.executorName = getItemValueByName(xmlCard, "HROBJID_3_TEXT");
      ordCard.signerName = getItemValueByName(xmlCard, "HROBJID_5_TEXT");

      // Поле "Важность"
      ordCard.cardUrgent =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "CHB_V"))
              ? 1
              : 0;

      //Сконвертируем таблицу согласования
      ordCard.routeTable =
          convertRouteTable(ordCard, routeTableData, routeTableNoteData);

      ordCard.fileTable =
          convertFileTable(ordCard, fileTableData, fileTableSignerData);

      //Сконвертируем таблицу итераций Рук-Пом
      ordCard.iterationTable = convertIterationTable(
          ordCard, iterationTableData, iterationTableNoteData);

      //Добавим РК Командировки в набор сконвертированных
      convertedCardList.add(ordCard);
    }
  }
}
