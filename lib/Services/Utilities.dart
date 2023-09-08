import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entity/Report.dart';
import '../Entity/User.dart';
import '../Pages/LoginPage.dart';
import '../pdf/Invoice.dart';
import '../pdf/pdf_invoice_api.dart';

class Utilities{
  final isPlatformDarkMode = Get.isPlatformDarkMode;// MediaQuery.of(context).platformBrightness==Brightness.dark;
  var width = Get.width;
  var height= Get.height;
  Future<String> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = await prefs.getString('phoneNum');
    return val!;
  }
}

class ReportUtilities{

  Future<void> addReport(String userId, String reportDetail, String ImagePath,String reportId) async {
    String phone =await Utilities().get();

    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phone);
    DocumentReference userDocRef = userCollectionRef.doc(userId);

    DocumentReference reportsCollectionRef = userDocRef.collection('Reports').doc();

    await reportsCollectionRef.set({
      'id': reportsCollectionRef.id,
      'userId': userId,
      'ImagePath': ImagePath,
      'reportDetail': reportDetail,
      'timestamp': FieldValue.serverTimestamp(),
    }).then(( _) {
      reportId = reportsCollectionRef.id;
      print('Rapor eklendi: ${reportsCollectionRef.id}');
    }).catchError((error) {
      print('Rapor ekleme işlemi başarısız oldu: $error');
    });
  }



  Future<List<Report>> getReport() async {
    String phone = await Utilities().get();
    CollectionReference userCollectionRef =
    FirebaseFirestore.instance.collection(phone);
    DocumentReference userDocRef = userCollectionRef.doc(LoginPage.user!.name);
    CollectionReference reportsCollectionRef = userDocRef.collection('Reports');

    QuerySnapshot querySnapshot = await reportsCollectionRef
        .orderBy("timestamp", descending: true) // Oluşturma tarihine göre sıralama
        .get();

    List<Report> reports = [];

    querySnapshot.docs.forEach((doc) {
      reports.add(
        Report(
          id: doc["id"],
          reportDetail: doc["reportDetail"],
          ImagePath: doc["ImagePath"],
          userId: doc["userId"],
          timestamp: doc['timestamp'].toDate(),
        ),
      );
    });

    print(reports);
    return reports;
  }

  Future<void> deleteReport(String reportId) async {
    String phone = await Utilities().get();
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
  Future<void> deleteReports(List<Report> reportIds,List<int> selectedItems) async {
    String phone = await Utilities().get();
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phone);
    // Kullanıcı adınızı düzenleyin, gerekirse kullanıcı oturumu kontrolünü yapın

    for (Report reportId in reportIds) {
      DocumentReference reportDocRef = userCollectionRef
          .doc(LoginPage.user!.name)
          .collection('Reports')
          .doc(reportId.id);

      try {
        await reportDocRef.delete();
        selectedItems.clear();
        print('Veri silindi: $reportId');
      } catch (error) {
        print('Silme işlemi başarısız oldu: $error');
      }
    }
  }

  Future<void> shareReportPdf(Report report) async {
    final date = DateTime.now();
    final _date=  DateFormat('dd.MM.yyyy').format(date);
    final invoice = Invoice(
      report: Report(
        ImagePath: report.ImagePath,
        reportDetail: report.reportDetail =="true"?" hastalik tespit edildi ":report.reportDetail ==""?"AI çalismamaktadir" :"Sağlikli görünüyorsunuz",
        userId: report.userId,
        id: report.id,
      ),
      info: InvoiceInfo(
        date: _date,
        description: 'Bu uygulamanin ürün haklari Diasoroath ekibine aittir.Uygulamanin dogruluk orani %60 dir. '
            'Hasta report detayi kisminda hastalik tespit edildi olarak görünüyorsaniz. '
            'Bir doktara görünmenizi tavsiye ediriz. Saglikli günler dileriz. ',
        number: '${DateTime.now().year}',
      ),
    );

    final pdf = await PdfInvoiceApi.generate(invoice);

    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/report_${report.id}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await Share.shareFiles([filePath]);

  }
}

class UserUtilities{
  Future<List<User>> getUsers() async {
    late List<User> users = [];
    String phone =await Utilities().get();
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phone);
    QuerySnapshot userQuerySnapshot = await userCollectionRef.get();
    userQuerySnapshot.docs.forEach((document) {
      Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
      User user = User(
        id: userData["id"],
        name: userData["name"],
        age: userData["age"],
        gender: userData["gender"],
        avatarUrl: userData["avatarUrl"],
        smoke: userData["smoke"],
      );
      users.add(user);
    });
    return  users;
  }
  Future<void> updateUser(String userId, String updatedValue) async {
    String phoneNum = await Utilities().get();

    CollectionReference collectionRef = FirebaseFirestore.instance.collection(phoneNum);
    DocumentReference documentRef = collectionRef.doc(userId);
    await documentRef.update({
      'avatarUrl': updatedValue.replaceAll("File:", ""),
    }).then((_) {
      print("Belge güncellendi: ${documentRef.id}");
    }).catchError((error) {
      print("Belge güncelleme işlemi başarısız oldu: $error");
    });
  }

  Future<void>  deleteUser(User user) async {
    String phone =await Utilities().get();
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phone);
    DocumentReference documentReference = userCollectionRef.doc(user.id);

    await documentReference.delete().then((value) {
      print('Veri silindi.');
    }).catchError((error) {
      print('Silme işlemi başarısız oldu: $error');
    });


  }

}

class RegisterUtilities{

  Future<void> createUser( String name, String value, String avatarUrl, String smoke, String age) async {
    String phoneNum = await Utilities().get();
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phoneNum);

    DocumentReference userDocRef = userCollectionRef.doc(name);

    await userDocRef.set({
      'id': userDocRef.id,
      'name': name,
      'gender': value=="1" ? "F" : value=="2"? "M":"MB",
      'avatarUrl': avatarUrl,
      'smoke': smoke,
      'age': age,
    }).then((_) {
      print('User created successfully');
    }).catchError((error) {
      print('Failed to create user: $error');
    });
  }
}