import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'dart:typed_data';
import 'dart:ui';

class PdfRawImage extends pdfWidgets.ImageProvider {
  final Uint8List? data;
  final Size? size;
  pdf.PdfDocument? document;

  PdfRawImage({this.data, this.size})
      : super(size!.width.toInt(), size.height.toInt(),
            pdf.PdfImageOrientation.topLeft, 72.0);

  @override
  pdf.PdfImage buildImage(pdfWidgets.Context context,
      {int? width, int? height}) {
    return pdf.PdfImage.file(
      document!,
      bytes: data!,
      orientation: orientation,
    );
  }
}