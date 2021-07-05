import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

class GraphicService {
  // Получение списка картинок PNG, обернутых в Image из PDF файла
  Future<List<Image>> getPNGImageListFromPDF(ByteData pdfByteData) async {
    List<Image> list = <Image>[];

    await for (var page
        in Printing.raster(pdfByteData.buffer.asUint8List(), dpi: 72)) {
      final page1 = await page.toPng();

      Image image = Image.memory(page1);
      list.add(image);
    }
    return list;
  }
}
