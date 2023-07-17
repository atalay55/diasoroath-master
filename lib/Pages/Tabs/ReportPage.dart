import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gokhan/Entity/Report.dart';
import 'package:gokhan/Pages/LoginPage.dart';
import 'package:gokhan/Pages/ReportPageDetail.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pdf/Invoice.dart';
import '../../pdf/pdf_invoice_api.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  List<int> selectedItems =[];
  List<Report> selectedReport =[];
  static late bool selecteModeOn ;

  Future<String> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = await prefs.getString('phoneNum');
    return val!;
  }

  Future<List<Report>> getEntity() async {
    String phone = await get();
    CollectionReference userCollectionRef =
    FirebaseFirestore.instance.collection(phone);
    DocumentReference userDocRef = userCollectionRef.doc(LoginPage.user!.name);
    CollectionReference reportsCollectionRef =
    userDocRef.collection('Reports');

    QuerySnapshot querySnapshot = await reportsCollectionRef.get();

    List<Report> reports = [];

    querySnapshot.docs.forEach((doc) {
      reports.add(
        Report(
          id: doc["id"],
          reportDetail: doc["reportDetail"],
          ImagePath: doc["ImagePath"],
          userId: doc["userId"],
        ),
      );
    });
    return reports;
  }

  Future<void> deleteEntity(String reportId) async {
    String phone = await get();
    CollectionReference userCollectionRef =
    FirebaseFirestore.instance.collection(phone);
    DocumentReference reportDocRef = await userCollectionRef
        .doc(LoginPage.user!.name)
        .collection('Reports')
        .doc(reportId);

    await reportDocRef.delete().then((value) {
      print('Veri silindi.');
    }).catchError((error) {
      print('Silme işlemi başarısız oldu: $error');
    });
  }
  Future<void> deleteEntities(List<Report> reportIds) async {
    String phone = await get();
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phone);
 // Kullanıcı adınızı düzenleyin, gerekirse kullanıcı oturumu kontrolünü yapın

    for (Report reportId in reportIds) {
      DocumentReference reportDocRef = userCollectionRef
          .doc(LoginPage.user!.name)
          .collection('Reports')
          .doc(reportId.id);

      try {
        await reportDocRef.delete();
        print('Veri silindi: $reportId');
      } catch (error) {
        print('Silme işlemi başarısız oldu: $error');
      }
    }
  }



  Future<void> shareReportPdf(Report report) async {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 1));

    final invoice = Invoice(
      report: Report(
        ImagePath: report.ImagePath,
        reportDetail: report.reportDetail,
        userId: report.userId,
        id: report.id,
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'Bu uygulama vs Bu uygulama vsBu uygulama vsBu uygulama vsBu uygulama vs ',
        number: '${DateTime.now().year}',
      ),
    );

    final pdf = await PdfInvoiceApi.generate(invoice);

    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/report_${report.id}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await Share.shareFiles([filePath]);
    /*
    final pdf = pw.Document();

    final image =await  PdfImage.file(
      pdf.document,
      bytes: await File(report.ImagePath.replaceAll("'", "")).readAsBytes(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return
            pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child:  pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child:pw.Text("User Name: ${report.userId}",style: pw.TextStyle(fontSize: 20)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child:pw.Text("Photo path:\n${report.ImagePath}",style: pw.TextStyle(fontSize: 20)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child:pw.Text("Report Id: ${report.id}",style: pw.TextStyle(fontSize: 20)),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(8),
                      child:pw.Text("Report Detail: ${report.reportDetail}",style: pw.TextStyle(fontSize: 20)),
                    ),




                  ],

                )
            );

        },
      ),
    );

    // PDF dosyasını kaydet
    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/report_${report.id}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Paylaşma işlemini gerçekleştir
   await Share.shareFiles([filePath]);
   */

  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    selecteModeOn=selectedItems.isNotEmpty;


    return Scaffold(
      body:FutureBuilder<List<Report>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("1");
            return Center(
              child: Column(
                children: [
                  Text('Veriler alınamadı'),
                ],
              ),
            );
          } else if (snapshot.data == null) {
            print("2");
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Veriler alınamadı'),
                ],
              ),
            );
          } else {
            return snapshot.data!.isNotEmpty
                ? ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                File file = File(
                    snapshot.data![index].ImagePath.replaceAll("'", ""));

                return GestureDetector(
                  onLongPress: (){
                    setState(() {
                      selectedItems.add(index);
                      selectedReport.add(snapshot.data![index]);
                      selecteModeOn = true;
                    });
                  },
                  child: Dismissible(
                    key: Key(snapshot.data![index].id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.redAccent,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Delete operation
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Do you want to delete this report?'),
                              content: Form(
                                child: ElevatedButton(
                                  child: Text("Yes"),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                      Colors.redAccent,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await deleteEntity(snapshot.data![index].id);
                                    setState(() {

                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else if (direction == DismissDirection.endToStart) {

                        await shareReportPdf(snapshot.data![index]);
                      }
                    },
                    child: GestureDetector(
                      onTap: () {
                        if(selecteModeOn){
                          setState(() {

                            if(selectedItems.contains(index)){
                              selectedItems.remove(index);
                              selectedReport.remove(snapshot.data![index]);

                            }
                            else{
                              selectedItems.add(index);
                              selectedReport.add(snapshot.data![index]);

                            }
                          });

                        }
                        else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReportPageDetail(snapshot.data![index]),
                            ),
                          );
                        }

                      },
                      child: Container(
                        color: selectedItems.contains(index)?Colors.blueAccent:Colors.white,
                        height: 100,
                        width: width,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  child: Image.file(
                                    file,
                                    width: width / 5,
                                    height: width / 5,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Text(
                                  "Report ${(snapshot.data!.length - index).toString()}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : Center(child: Text("You do not have any report"));
          }
        },
        future: getEntity(),
      ),
      floatingActionButton: selecteModeOn ?FloatingActionButton(
        onPressed: () async{
         await deleteEntities(selectedReport);
         setState(() {

         });
          },
        child: Icon(Icons.remove),
      ):null
    );
  }
}
