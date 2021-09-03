import 'package:MWPX/data_structure/card/body/btrip/BTripCard.dart';
import 'package:MWPX/data_structure/card/body/btrip/DelegationTableItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/longtext/LongTextAssistant.dart';
import 'package:xml/xml.dart' as xml;

/// Класс для получения атрибутов РК Командировки
class BTripExporter extends CommonCardExporter {
  ///Список сконвертированных РК, полученных из ЕАСД
  List<BTripCard> convertedCardList = [];

  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
   <soapenv:Header/>
   <soapenv:Body>
      <urn:ZAWPWS03_EX_CARD_010010>
         <IT_LOAD_LIST>
            ${super.loadListXML}
         </IT_LOAD_LIST>         
         <I_NEED_LOCK>X</I_NEED_LOCK>
      </urn:ZAWPWS03_EX_CARD_010010>
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
    xml.XmlElement delegationData =
        super.parsedXml.findAllElements('ET_DELEGATION_DATA').single;

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
      BTripCard btripCard = new BTripCard();

      btripCard.logsys = getItemValueByName(xmlCard, "LOGSYS");
      btripCard.dokar = getItemValueByName(xmlCard, "DOKAR");
      btripCard.doknr = getItemValueByName(xmlCard, "DOKNR");
      btripCard.dokvr = getItemValueByName(xmlCard, "DOKVR");
      btripCard.doktl = getItemValueByName(xmlCard, "DOKTL");

      btripCard.doknrTRUNC = getItemValueByName(xmlCard, "DOKNR_TRUNC");

      btripCard.createdDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CREATED_ON"),
          getItemValueByName(xmlCard, "CREATED_TM"));
      btripCard.changedDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CHANGED_ON"),
          getItemValueByName(xmlCard, "CHANGED_TM"));

      if (btripCard.changedDT.year == 1900) {
        btripCard.changedDT = btripCard.createdDT;
      }

      btripCard.documentType = "";

      btripCard.isInternational = (getItemValueByName(xmlCard, "INTNL") == "I");

      btripCard.countryText = getItemValueByName(xmlCard, "COUNTRY_TEXT");
      btripCard.nCity = getItemValueByName(xmlCard, "NCITY");
      ;
      btripCard.begDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "BEGDA"), "00:00:00");
      btripCard.endDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "ENDDA"), "00:00:00");
      btripCard.calendarDays =
          int.parse(getItemValueByName(xmlCard, "CALENDDAYS"));
      btripCard.transportType = getItemValueByName(xmlCard, "TRANSP");

      btripCard.globalFlag =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "GLOBFLAG"));

      btripCard.planPunkt = getItemValueByName(xmlCard, "PLPUNKT");

      btripCard.planFlag =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "PLANFLAG"));

      btripCard.goalText = lta.getTextString(btripCard.dokar, btripCard.doknr,
          btripCard.dokvr, btripCard.doktl, "DOCTEXT");
      btripCard.addInfText = lta.getTextString(btripCard.dokar, btripCard.doknr,
          btripCard.dokvr, btripCard.doktl, "DOCCOMMENT");

      btripCard.signerName = getItemValueByName(xmlCard, "HROBJID_10_TEXT");
      btripCard.signerDepartment =
          getItemValueByName(xmlCard, "HROBJID_9_TEXT");

      String sFirstDelegate = "";

      for (var xmlDelegate in delegationData.children) {
        if (getItemValueByName(xmlDelegate, "DOKNR") == btripCard.doknr) {
          DelegationTableItem deleItem = new DelegationTableItem();

          deleItem.logsys = btripCard.logsys;
          deleItem.dokar = btripCard.dokar;
          deleItem.doknr = btripCard.doknr;
          deleItem.dokvr = btripCard.dokvr;
          deleItem.doktl = btripCard.doktl;
          deleItem.recNr = getItemValueByName(xmlDelegate, "RECNR");

          deleItem.begDT = SapTypeHelper.stringToDateTime(
              getItemValueByName(xmlDelegate, "BEGDA"), "00:00:00");
          deleItem.endDT = SapTypeHelper.stringToDateTime(
              getItemValueByName(xmlDelegate, "ENDDA"), "00:00:00");

          deleItem.calendarDays =
              int.parse(getItemValueByName(xmlDelegate, "CALENDDAYS"));
          deleItem.transportType = getItemValueByName(xmlDelegate, "TRANSP");
          deleItem.fioText = getItemValueByName(xmlDelegate, "FIO_TEXT");
          deleItem.postText = getItemValueByName(xmlDelegate, "POST_TEXT");
          deleItem.orgText = getItemValueByName(xmlDelegate, "ORG_TEXT");

          btripCard.delegationTable.add(deleItem);

          sFirstDelegate = deleItem.fioText;
        }
      }

      btripCard.content =
          "$sFirstDelegate, с ${btripCard.begDTText} по ${btripCard.endDTText}, ${btripCard.nCity} (${btripCard.countryText})";

      //Сконвертируем таблицу согласования
      btripCard.routeTable =
          convertRouteTable(btripCard, routeTableData, routeTableNoteData);

      //Сконвертируем таблицу итераций Рук-Пом
      btripCard.iterationTable = convertIterationTable(
          btripCard, iterationTableData, iterationTableNoteData);

      //Добавим РК Командировки в набор сконвертированных
      convertedCardList.add(btripCard);
    }
  }
}
