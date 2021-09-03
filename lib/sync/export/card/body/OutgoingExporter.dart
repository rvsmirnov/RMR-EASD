import 'package:MWPX/data_structure/card/body/outgoing/AddresseeTableItem.dart';
import 'package:MWPX/data_structure/card/body/outgoing/OutgoingCard.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/longtext/LongTextAssistant.dart';
import 'package:xml/xml.dart' as xml;

class OutgoingExporter extends CommonCardExporter {
  ///Список сконвертированных РК, полученных из ЕАСД
  List<OutgoingCard> convertedCardList = [];

  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <soapenv:Header/>
            <soapenv:Body>
                <urn:ZAWPWS03_EX_CARD_010005>
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

                </urn:ZAWPWS03_EX_CARD_010005>
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

    xml.XmlElement addresseeTableData =
        super.parsedXml.findAllElements('ET_ADDR_DATA').single;

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
      OutgoingCard outgCard = new OutgoingCard();
      outgCard.logsys = getItemValueByName(xmlCard, "LOGSYS");
      outgCard.dokar = getItemValueByName(xmlCard, "DOKAR");
      outgCard.doknr = getItemValueByName(xmlCard, "DOKNR");
      outgCard.dokvr = getItemValueByName(xmlCard, "DOKVR");
      outgCard.doktl = getItemValueByName(xmlCard, "DOKTL");
      outgCard.doknrTRUNC = getItemValueByName(xmlCard, "DOKNR_TRUNC");

      outgCard.createdDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CREATED_ON"),
          getItemValueByName(xmlCard, "CREATED_TM"));
      outgCard.changedDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CHANGED_ON"),
          getItemValueByName(xmlCard, "CHANGED_TM"));

      if (outgCard.changedDT.year == 1900) {
        outgCard.changedDT = outgCard.createdDT;
      }

      outgCard.regNum = SapTypeHelper.regNumToString(
          getItemValueByName(xmlCard, "PRECODE"),
          getItemValueByName(xmlCard, "REGNUM"),
          getItemValueByName(xmlCard, "CODE"));

      outgCard.regDate = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "REGDATE"), "00:00:00");

      outgCard.documentType = getItemValueByName(xmlCard, "VIDDOC");

      outgCard.content = lta.getTextString(outgCard.dokar, outgCard.doknr,
          outgCard.dokvr, outgCard.doktl, "DOCTEXT");

      outgCard.executorName = getItemValueByName(xmlCard, "HROBJID_8_TEXT");
      outgCard.executorDepartment =
          getItemValueByName(xmlCard, "HROBJID_7_TEXT");
      outgCard.signerName = getItemValueByName(xmlCard, "HROBJID_4_TEXT");

      outgCard.pdfaConvFlag = SapTypeHelper.stringToBool(
              getItemValueByName(xmlCard, "PDFA_CONV_FLAG"))
          ? 1
          : 0;

      outgCard.cardUrgent =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "CHB_V"))
              ? 1
              : 0;

      //Сконвертируем таблицу адресатов
      for (var xmlAddr in addresseeTableData.children) {
        if (getItemValueByName(xmlAddr, "DOKNR") == outgCard.doknr) {
          AddresseeTableItem addr = new AddresseeTableItem();
          addr.logsys = outgCard.logsys;
          addr.dokar = outgCard.dokar;
          addr.doknr = outgCard.doknr;
          addr.dokvr = outgCard.dokvr;
          addr.doktl = outgCard.doktl;
          addr.recNr = getItemValueByName(xmlAddr, "RECNR");
          addr.addresseeName = getItemValueByName(xmlAddr, "FIO_TEXT");
          addr.addresseeDepartment = getItemValueByName(xmlAddr, "ORG_TEXT");
          addr.addresseePosition = getItemValueByName(xmlAddr, "POST_TEXT");
          outgCard.addresseeTable.add(addr);
        }
      }

      //Сконвертируем таблицу согласования
      outgCard.routeTable =
          convertRouteTable(outgCard, routeTableData, routeTableNoteData);

      //Сконвертируем таблицу файлов
      outgCard.fileTable =
          convertFileTable(outgCard, fileTableData, fileTableSignerData);

      //Сконвертируем таблицу итераций Рук-Пом
      outgCard.iterationTable = convertIterationTable(
          outgCard, iterationTableData, iterationTableNoteData);

      //Добавим РК Исходящего в набор сконвертированных
      convertedCardList.add(outgCard);
    }
  }
}
