import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:open_file/open_file.dart';
import 'package:painter/painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdfRender;
import 'package:printing/printing.dart';
import 'package:split_view/split_view.dart';

class CustomSingleChildLayoutWidgetStateExample extends StatelessWidget {
  
    final ValueNotifier<Size> _size = ValueNotifier<Size>(const Size(200.0, 100.0));
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Woolha.com Flutter Tutorial'),
        ),
        body: Column(
          children: [
            CustomSingleChildLayout(
              delegate: CustomLayoutDelegate(_size),
              child: Container(
                color: Colors.red,
                width: 50,
                height: 300,
              ),
            ),
          ],
        ),
  
      );
    }
  }
  
  class CustomLayoutDelegate extends SingleChildLayoutDelegate {
  
    CustomLayoutDelegate(this.size) : super(relayout: size);
  
    final ValueNotifier<Size> size;
  
    @override
    Size getSize(BoxConstraints constraints) {
      return size.value;
    }
  
    @override
    BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
      return BoxConstraints.tight(size.value / 2);
    }
  
    @override
    Offset getPositionForChild(Size size, Size childSize) {
      return Offset(size.width / 4, size.height / 4);
    }
  
    @override
    bool shouldRelayout(CustomLayoutDelegate oldDelegate) {
      return size != oldDelegate.size;
    }
  }