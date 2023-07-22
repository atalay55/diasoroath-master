
import '../Entity/Report.dart';

class Invoice {
  final InvoiceInfo info;
  final Report report;

  const Invoice({
    required this.info,
    required this.report,

  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final String date;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
  });
}

class InvoiceItem {

  final String userId;
  final String ImagePath;
  final String reportDetail;


  const InvoiceItem({
    required this.userId,
    required this.ImagePath,
    required this.reportDetail,
  });
}