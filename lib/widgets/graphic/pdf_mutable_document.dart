import 'package:MWPX/widgets/graphic/pdf_mutable_page.dart';

class PdfMutableDocument {
  String _filePath;
  final List<PdfMutablePage> _pages;

  PdfMutableDocument({List<PdfMutablePage>? pages, String? filePath})
      : _pages = pages ?? [],
        _filePath = filePath!;

  void addPage(PdfMutablePage page) => _pages.add(page);

  PdfMutablePage getPage(int index) => _pages[index];


}