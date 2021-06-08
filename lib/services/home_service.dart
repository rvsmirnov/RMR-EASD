import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeService {
  List<Map> foldersHomeDataList = [
    {
      'folderCode': 1,
      'folderName': 'Командировки',
      'folderCount': 7,
      'folderIcon': Icons.date_range,
    },
    {
      'folderCode': 2,
      'folderName': 'Отпуска',
      'folderCount': 3,
      'folderIcon': Icons.free_breakfast,
    },
    {
      'folderCode': 3,
      'folderName': 'На решение',
      'folderCount': 12,
      'folderIcon': Icons.description,
    },
    {
      'folderCode': 4,
      'folderName': 'Отчеты',
      'folderCount': 1,
      'folderIcon': Icons.library_books,
    },
    {
      'folderCode': 5,
      'folderName': 'На Соглосование',
      'folderCount': 154,
      'folderIcon': Icons.assignment,
    },
    {
      'folderCode': 6,
      'folderName': 'На подписание',
      'folderCount': 2,
      'folderIcon': Icons.edit,
    },
    {
      'folderCode': 7,
      'folderName': 'На исполнение',
      'folderCount': 5,
      'folderIcon': Icons.flag,
    },
    {
      'folderCode': 8,
      'folderName': 'На контроль',
      'folderCount': 76,
      'folderIcon': Icons.warning_outlined,
    },
    {
      'folderCode': 9,
      'folderName': 'Создать поручение',
      'folderCount': 12,
      'folderIcon': Icons.edit,
    },
    {
      'folderCode': 10,
      'folderName': 'На ознакомление',
      'folderCount': 10,
      'folderIcon': Icons.contacts_rounded,
    },
    {
      'folderCode': 11,
      'folderName': 'К совещанию',
      'folderCount': 1223,
      'folderIcon': Icons.task,
    },
  ];
}
