class ReportService {
  // Заглушка на случай не нахождения иконки '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>'''
  List<Map> foldersReportDataList = [
    {
      'folderCode': 00004,
      'folderName': 'На исполнении',
      'folderCount': 1,
      'svgCode': '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': 00005,
      'folderName': 'Исполенные',
      'folderCount': 154,
      'svgCode': '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
    {
      'folderCode': 000014,
      'folderName': 'У меня на исполнении',
      'folderCount': 1223,
      'svgCode': '''<svg style="width:24px;height:24px" viewBox="0 0 74 74"> <path d=""/></svg>''',
    },
  ];

  List<Map>? addSvgIcons(
      {List<Map>? foldersReportDataList, List<Map>? reportSvgIconsList}) {
    foldersReportDataList!.forEach((element) {
      // Map reportSvgIcon =
      reportSvgIconsList!.forEach((el) {
        if (element['folderCode'] == el['folderCode']) {
          element['svgCode'] = el['svgCode'];
        }
      });
    });
    return foldersReportDataList;
  }
}