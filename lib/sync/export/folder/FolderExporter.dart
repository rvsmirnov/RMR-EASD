import 'package:MWPX/data_processing/folder/FolderOperator.dart';
import 'package:MWPX/data_structure/folder/FolderItem.dart';
import 'package:MWPX/sync/ConnectionConfig.dart';
import 'package:MWPX/sync/export/CommonExporter.dart';
import 'package:xml/xml.dart' as xml;

class FolderExporter extends CommonExporter {
  ///Список папок, полученных из ЕАСД
  late List<FolderItem> _easdFolderList;

  /// Список папок из локальной БД.
  late List<FolderItem> _localFolderList;

  ///Конструктор, инициализация
  FolderExporter() {
    _easdFolderList = [];
    _localFolderList = [];
  }

  ///Установка параметров экспорта папок
  void setParameters(String pUserName, List<FolderItem> pLocalFolderList) {
    envelop =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:sap-com:document:sap:rfc:functions">
            <soapenv:Header/>
            <soapenv:Body>
                <urn:ZAWPWS03_EX_FOLDERS>         
                  <I_DEF_USER>DEF_FLD_SET</I_DEF_USER>
                  <I_USERNAME>$pUserName</I_USERNAME>
                </urn:ZAWPWS03_EX_FOLDERS>
            </soapenv:Body>
          </soapenv:Envelope>''';
    _localFolderList = pLocalFolderList;
  }

  @override
  Future<void> doExport(ConnectionConfig pConConf) async {
    //Запросим данные из ЕАСД
    await getRemoteResponse(
        pConConf.fullEasdURL, pConConf.encodedLoginPassword, envelop);

    //Получим список папок
    xml.XmlElement folderData =
        super.parsedXml.findAllElements('ET_FOLDERS').single;

    //Разберем его в массив структур
    for (var item in folderData.children) {
      FolderItem fi = new FolderItem();
      fi.folderCode = getItemValueByName(item, "CODE");
      fi.folderName = getItemValueByName(item, "FOLDER_NAME");
      fi.recNr = int.parse(getItemValueByName(item, "RECNR"));
      fi.folderType = getItemValueByName(item, "FOLDER_TYPE");
      fi.parentCode = getItemValueByName(item, "PARENT_CODE");
      _easdFolderList.add(fi);
    }

    //Сравним с существующим списком папок
    for (var folder in _easdFolderList) {
      FolderItem fi = _localFolderList.singleWhere(
          (element) => element.folderCode == folder.folderCode,
          orElse: () => new FolderItem());

      if (fi.folderCode != "") {
        if (fi.folderName != folder.folderName ||
            fi.recNr != folder.recNr ||
            fi.folderType != folder.folderType ||
            fi.parentCode != folder.parentCode) {
          FolderOperator.updateFolder(folder);
        }
      } else {
        FolderOperator.insertFolder(folder);
      }
    }

    //Удалим неактуальные папки
    for (var folder in _localFolderList) {
      FolderItem fi = _easdFolderList.singleWhere(
          (element) => element.folderCode == folder.folderCode,
          orElse: () => new FolderItem());
      if (fi.folderCode == "") {
        FolderOperator.deleteFolder(folder);
        //
        //Тут надо добавить удаление всех привязок РК из удаляемых папок
        //
      }
    }
  }
}
