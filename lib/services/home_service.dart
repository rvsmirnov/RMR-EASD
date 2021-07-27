import 'package:MWPX/data_processing/DB.dart';

import 'package:MWPX/data_processing/folder/FolderOperator.dart';
import 'package:MWPX/styles/mwp_icons.dart';
import 'package:flutter/material.dart';

class HomeService {
  Future<void> fillFoldersFromDB() async {
    //var folderList = await DB.selectTable(FolderTableRow.table);
    var folderList = await FolderOperator.getFolderList("");

    foldersHomeDataList.clear();

    for (var fold in folderList) {
      foldersHomeDataList.add({
        'folderCode': fold.folderCode,
        'folderName': fold.folderName,
        'folderCount': fold.allCountText,
        'folderType': fold.folderType,
        'svgCode':
            '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>'''
      });
    }
  }

  // Заглушка на случай не нахождения иконки '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>'''
  List<Map> foldersHomeDataList = [
    {
      'folderCode': '00001',
      'folderName': 'Командировки',
      'folderCount': 7,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00002',
      'folderName': 'Отпуска',
      'folderCount': 3,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00003',
      'folderName': 'На решение',
      'folderCount': 12,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00004',
      'folderName': 'Отчеты',
      'folderCount': 1,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00005',
      'folderName': 'На согласование',
      'folderCount': 154,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00006',
      'folderName': 'На подписание',
      'folderCount': 2,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00007',
      'folderName': 'На исполнение',
      'folderCount': 5,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00008',
      'folderName': 'На контроль',
      'folderCount': 76,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00009',
      'folderName': 'Создать поручение',
      'folderCount': null,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '00012',
      'folderName': 'На ознакомление',
      'folderCount': 100,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': '000015',
      'folderName': 'К совещанию',
      'folderCount': 1223,
      'svgCode':
          '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
  ];

  List<Map>? addSvgIcons(
      {List<Map>? foldersHomeDataList, List<Map>? homeSvgIconsList}) {
    foldersHomeDataList!.forEach((element) {
      // Map homeSvgIcon =
      homeSvgIconsList!.forEach((el) {
        if (element['folderCode'] == el['folderCode']) {
          element['svgCode'] = el['svgCode'];
        }
      });
    });
    return foldersHomeDataList;
  }
}
