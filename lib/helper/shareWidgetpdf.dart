import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:share_plus/share_plus.dart';

class ShareWiggetAsPdf {
  Widget widget;
  late Uint8List _imageFile;
  String name;

  pw.Document pdf = pw.Document();
    //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  ShareWiggetAsPdf({required this.widget, required this.name});
  sharePdf() async{
    await screenshotController.captureFromWidget(widget).then((capturedImage) {_imageFile = capturedImage;});
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pw.MemoryImage(_imageFile), fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    String tempPath = (await getTemporaryDirectory()).path;
    final file = File("$tempPath/$name.pdf");
    await file.writeAsBytes(await pdf.save());
    final result = await Share.shareXFiles([XFile(file.path)]);
    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the picture!');
    }
  }
}