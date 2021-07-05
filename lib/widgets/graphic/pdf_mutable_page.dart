import 'dart:ui';
import 'package:pdf/widgets.dart' as pdfWidgets;

// оболочки для pdfWidgets.Document и pdfWidgets.Page,
// которые будут содержать фоновые изображения и размер страницы
import 'package:MWPX/widgets/graphic/pdf_raw_image.dart';

class PdfMutablePage {
  final PdfRawImage? _background;
  final List<pdfWidgets.Widget> _stackedItems;

  PdfMutablePage({PdfRawImage? background})
      : _background = background,
        _stackedItems = [];

  void add({pdfWidgets.Widget? item}) {
    _stackedItems.add(item!);
  }

  Size get size => _background!.size!;

}