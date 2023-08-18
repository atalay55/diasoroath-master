import 'dart:io';
import 'package:Diasoroath/Entity/Report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'Invoice.dart';

class PdfInvoiceApi {

  static Future<pw.Document> generate(Invoice invoice) async {
    final imageJpg = (await File(invoice.report.ImagePath.replaceAll("'", "")));
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (context) =>
      [
        buildHeader(invoice),
        pw.SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildImage(imageJpg: imageJpg.readAsBytesSync()),
        buildSimpleText(title: "Report Id :", value: invoice.report.id),
        buildSimpleText(title: "User Name :", value: invoice.report.userId),
        buildSimpleText(title: "Report Detail: ", value: invoice.report.reportDetail),

        pw.Divider(),
      ],
    ));

    return pdf;
  }

  static pw.Widget buildHeader(Invoice invoice) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                height: 50,
                width: 50,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.report),
              buildInvoiceInfo(invoice.info),

            ],

          ),

        ],
      );

  static pw.Widget buildCustomerAddress(Report customer) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
              customer.userId, style: pw.TextStyle(fontWeight: pw.FontWeight.bold ,fontSize: 30)),
        ],
      );

  static pw.Widget buildInvoiceInfo(InvoiceInfo info) {

    final titles = [
      'broadcasting Number:',
      'broadcasting Date:',

    ];
    final data = [
      '${info.number}',
      '${info.date.toString()}',
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static pw.Widget buildTitle(Invoice invoice) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Diasoroath',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          pw.Text(invoice.info.description),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold ,fontSize: PdfPageFormat.mm*5 );

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: PdfPageFormat.mm*2),
          child: pw.Text(title, style: style),
        ),

        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: PdfPageFormat.mm*2),
          child: pw.Text(value ,style: style),
        ),


      ],
    );
  }

  static pw.Widget buildImage ({
  required  final imageJpg ,
  })  {
    final image = pw.MemoryImage(imageJpg);
    return pw.Container(
      height: 100,
      width: 250,
      child: pw.Row(
        children: [
          pw.Center(
            child: pw.ClipRRect(
              verticalRadius: 32,
              child:   pw.Image(image),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
