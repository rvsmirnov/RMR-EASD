import 'dart:io';

import 'package:MWPX/widgets/graphic/pdf_mutable_document.dart';
import 'package:MWPX/widgets/graphic/pdf_mutable_page.dart';
import 'package:MWPX/widgets/graphic/pdf_raw_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdfRender;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/pdf.dart' as pdf;

class GraphicServiceOld {

  /// методы создания из PDF списка картинок. Начало

  // превращаем pdf в фаил, для последующего превращения в список картинок
  static Future<File> getFileFromAssets(String filename) async {
    assert(filename != null);
    final byteData = await rootBundle.load(filename);
    var name = filename.split(Platform.pathSeparator).last;
    var absoluteName = '${(await getLibraryDirectory()).path}/$name';
    final file = File(absoluteName);

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

    // возвращает pdf документ в виде картинок
  static Future<PdfMutableDocument> pdfMutableDocumentAsset(String assetName) async {
    var copy = await getFileFromAssets(assetName);
    final rawImages = await loadPdf(copy.path);
    final pages =
        rawImages.map((raw) => PdfMutablePage(background: raw)).toList();
    return PdfMutableDocument(
        pages: pages, filePath: copy.uri.pathSegments.last);
  }

  // получения данных страниц одну за другой.
  // Для каждой страницы мы визуализируем изображение с точным размером страницы,
  // а затем сохраняем данные (необработанное изображение и размер) в экземпляре PdfRawImage.
  // В итоге получаем список PdfRawImage, кот являются PdfImage
  static Future<List<PdfRawImage>> loadPdf(String path) async {
    var file = pdfRender.PdfImageRendererPdf(path: path);
    await file.open();
    var count = await file.getPageCount();
    var images = <PdfRawImage>[];
    for (var i = 0; i < count; i++) {
      var size = await file.getPageSize(pageIndex: 0);
      var rawImage = await file.renderPage(
        background: Colors.transparent,
        x: 0,
        y: 0,
        width: size.width,
        height: size.height,
        scale: 1.0,
        pageIndex: i,
      );
      images.add(PdfRawImage(
        data: rawImage,
        size: Size(size.width.toDouble(), size.height.toDouble()),
      ));
    }
    return images;
  }

  /// методы создания из PDF списка картинок. Конец

  // создание документа pdf
  // мы определяем pdfWidgets.Page того же размера, что и полученное изображение,
  // названное в этом примере «_background».
  pdfWidgets.Page pdfMutablePageBuild({pdfWidgets.Document? document, PdfRawImage? background, List<pdfWidgets.Widget>? stackedItems}) {
    background!.document = document!.document;
    final format =
        pdf.PdfPageFormat(background.size!.width, background.size!.height);
    return pdfWidgets.Page(
        pageFormat: format,
        orientation: pdfWidgets.PageOrientation.portrait,
        build: (context) {
          return pdfWidgets.Stack(
            children: [
              pdfWidgets.Image(background),
              ...stackedItems!,
            ],
          );
        });
  }

  // создание pdf из картинок
  pdfWidgets.Document pdfMutableDocumentBuild({List<PdfMutablePage>? pages, PdfRawImage? background, List<pdfWidgets.Widget>? stackedItems}) {
    var doc = pdfWidgets.Document();
    pages!.forEach((page) => doc.addPage(pdfMutablePageBuild(document: doc, background: background, stackedItems: stackedItems)));
    return doc;
  }

  Future<File> pdfMutableDocumentSave({String? filename, String? filePath, List<PdfMutablePage>? pages, PdfRawImage? background, List<pdfWidgets.Widget>? stackedItems}) async {
    return await save(pdfMutableDocumentBuild(pages: pages, background: background, stackedItems: stackedItems), filename ?? filePath!);
  }

  // Сохранить документ
  static Future<File> save(pdfWidgets.Document document, String filename,
      {String? directory}) async {
    final dir = directory ?? (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir${Platform.pathSeparator}$filename');
    return file.writeAsBytes(await document.save());
  }
}
