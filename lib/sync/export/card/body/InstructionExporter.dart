import 'package:MWPX/data_structure/card/body/instruction/ExecutorTableItem.dart';
import 'package:MWPX/data_structure/card/body/instruction/InstructionCard.dart';
import 'package:MWPX/data_structure/card/body/outgoing/AddresseeTableItem.dart';
import 'package:MWPX/data_structure/card/body/outgoing/OutgoingCard.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/SapTypeHelper.dart';
import 'package:MWPX/sync/export/card/body/CommonCardExporter.dart';
import 'package:MWPX/sync/longtext/LongTextAssistant.dart';
import 'package:xml/xml.dart' as xml;

class InstructionExporter extends CommonCardExporter {
  ///Список сконвертированных РК, полученных из ЕАСД
  List<InstructionCard> convertedCardList = [];

  void setParameters() {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <soapenv:Header/>
            <soapenv:Body>
                <urn:ZAWPWS03_EX_CARD_010002>
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

                </urn:ZAWPWS03_EX_CARD_010002>
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

    xml.XmlElement executorTableData =
        super.parsedXml.findAllElements('ET_EXEC_DATA').single;

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
      InstructionCard instrCard = new InstructionCard();
      instrCard.logsys = getItemValueByName(xmlCard, "LOGSYS");
      instrCard.dokar = getItemValueByName(xmlCard, "DOKAR");
      instrCard.doknr = getItemValueByName(xmlCard, "DOKNR");
      instrCard.dokvr = getItemValueByName(xmlCard, "DOKVR");
      instrCard.doktl = getItemValueByName(xmlCard, "DOKTL");
      instrCard.doknrTRUNC = getItemValueByName(xmlCard, "DOKNR_TRUNC");

      instrCard.createdDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CREATED_ON"),
          getItemValueByName(xmlCard, "CREATED_TM"));
      instrCard.changedDT = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CHANGED_ON"),
          getItemValueByName(xmlCard, "CHANGED_TM"));

      if (instrCard.changedDT.year == 1900) {
        instrCard.changedDT = instrCard.createdDT;
      }

      instrCard.regNum = SapTypeHelper.regNumToString(
          getItemValueByName(xmlCard, "PRECODE"),
          getItemValueByName(xmlCard, "REGNUM"),
          getItemValueByName(xmlCard, "CODE"));

      instrCard.regDate = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "REGDATE"), "00:00:00");

      instrCard.documentType = "";

      instrCard.content = lta.getTextString(instrCard.dokar, instrCard.doknr,
          instrCard.dokvr, instrCard.doktl, "PORTEXT");

      instrCard.initiatorName = getItemValueByName(xmlCard, "INITIATOR_NAME");
      instrCard.signerName = getItemValueByName(xmlCard, "SIGNER_NAME");
      instrCard.controllerName = getItemValueByName(xmlCard, "CONTROLLER_NAME");
      instrCard.ctrlType = getItemValueByName(xmlCard, "CTRL_TYPE");
      instrCard.urgency = getItemValueByName(xmlCard, "URGENCY");
      instrCard.chkConf =
          SapTypeHelper.stringToBool(getItemValueByName(xmlCard, "CHB_CONF"));
      instrCard.ctrlDate = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "CTRL_DATE"), "00:00:00");
      instrCard.factExecDate = SapTypeHelper.stringToDateTime(
          getItemValueByName(xmlCard, "FACT_EXEC_DATE"), "00:00:00");

      // Чем исполнено
      instrCard.executionText = lta.getTextString(instrCard.dokar,
          instrCard.doknr, instrCard.dokvr, instrCard.doktl, "PORISP");

      // Положение с выполнением
      instrCard.statusProcText = lta.getTextString(instrCard.dokar,
          instrCard.doknr, instrCard.dokvr, instrCard.doktl, "STATUS_PROC");

      // Пункт
      instrCard.punkt = getItemValueByName(xmlCard, "PUNKT_1");

      //Сконвертируем таблицу исполнителей
      for (var xmlExec in executorTableData.children) {
        if (getItemValueByName(xmlExec, "DOKNR") == instrCard.doknr) {
          ExecutorTableItem exec = new ExecutorTableItem();
          exec.logsys = instrCard.logsys;
          exec.dokar = instrCard.dokar;
          exec.doknr = instrCard.doknr;
          exec.dokvr = instrCard.dokvr;
          exec.doktl = instrCard.doktl;
          exec.recNr = getItemValueByName(xmlExec, "RECNR");

          exec.executorName = getItemValueByName(xmlExec, "EXECUTOR_NAME");
          exec.executorDepartment = getItemValueByName(xmlExec, "EXECUTOR_ORG");

          exec.respExec = SapTypeHelper.stringToBool(
              getItemValueByName(xmlExec, "CHB_OTV"));

          exec.executorCode = getItemValueByName(xmlExec, "EXECUTOR_NAME_CODE");
          exec.executorDepartmentCode =
              getItemValueByName(xmlExec, "EXECUTOR_ORG_CODE");

          instrCard.executorTable.add(exec);
        }
      }

      //Сконвертируем таблицу согласования
      instrCard.routeTable =
          convertRouteTable(instrCard, routeTableData, routeTableNoteData);

      //Сконвертируем таблицу файлов
      instrCard.fileTable =
          convertFileTable(instrCard, fileTableData, fileTableSignerData);

      //Сконвертируем таблицу итераций Рук-Пом
      instrCard.iterationTable = convertIterationTable(
          instrCard, iterationTableData, iterationTableNoteData);

      //Добавим РК Исходящего в набор сконвертированных
      convertedCardList.add(instrCard);
    }
  }
}
