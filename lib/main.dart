import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gokhan/Pages/LoginPage.dart';
import 'package:gokhan/Services/Validation/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  runApp(MyApp(isFirstRun: isFirstRun));
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({Key? key, required this.isFirstRun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diasoroath',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(),
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.dark(),
      ),
      home: isFirstRun ? MyFirstRunPage() : MyHomePage(),
    );
  }
}

class MyFirstRunPage extends StatefulWidget {
  @override
  _MyFirstRunPageState createState() => _MyFirstRunPageState();
}

class _MyFirstRunPageState extends State<MyFirstRunPage> {
  final TextEditingController ageController = TextEditingController();
  String phoneNumber = '';
  final _formKey = GlobalKey<FormState>();


  Future<void> getPhoneNumber() async {
    if (await Permission.contacts.isGranted) {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null && contact.phones != null && contact.phones!.isNotEmpty) {
        phoneNumber = contact.phones!.first.value!;
        ageController.text = phoneNumber;
      } else {
        print('Telefon numarası bulunamadı.');
      }
    } else {
      // İzin talep et
      PermissionStatus status = await Permission.contacts.request();
      if (status.isGranted) {
        // Rehberi aç ve kişi seçme ekranını göster
        final Contact? contact = await ContactsService.openDeviceContactPicker();
        if (contact != null && contact.phones != null && contact.phones!.isNotEmpty) {
          phoneNumber = Validation.checkPhoneNum(contact.phones!.first.value!);
        } else {
          print('Telefon numarası bulunamadı.');
        }
      } else {
        print('Rehbere erişim izni reddedildi.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
    final double width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text('Diasoroath'),
        toolbarHeight: width/5,
        backgroundColor:isDark? Colors.white10: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: width / 6, horizontal: width / 20),
                child: Text(
                  'Please enter phone number',
                  style: TextStyle(fontSize:width/18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: width / 15, left: width / 15, right: width / 15),
                child: TextFormField(

                  controller: ageController,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(fontSize: width / 22,),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: isDark? Colors.white:Colors.purpleAccent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.green),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    label: Text(
                      phoneNumber.isNotEmpty ? "${phoneNumber}" : "Phone number"
                    ),
                    hintText: "${phoneNumber}",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone number cannot be left empty.";
                    }
                    if (!value.contains(RegExp(r"[0123456789]"))) {
                      return "Invalid format for phone number, please enter a valid one.";
                    }
                    if (value.contains(RegExp(r"[a-zA-Z]"))) {
                      return "Invalid format for phone number, please enter a valid one.";
                    } else if (!value.startsWith("0")) {
                      return "lütfen numaranın 0 ile başladığına emin olunuz";
                    }
                    else if(value.contains(" ")){
                      return "lütfen numarınızı boşluk olmadan giriniz";
                    }
                    else if (value.length != 11) {
                      return "yanlış veya eksik numara girdiniz";
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(
                height: width/9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: isDark? Colors.white24: Colors.deepPurpleAccent, // Background color
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('Select Phone', style: TextStyle(fontSize: width / 20)),
                  onPressed: () async {
                    await getPhoneNumber();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: width / 15.0),
                child: SizedBox(
                  height: width/10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: isDark? Colors.white24: Colors.deepPurpleAccent,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text('Send', style: TextStyle(fontSize: width / 20)),
                    onPressed: () async {
                      if (ageController.text.isNotEmpty || phoneNumber.isNotEmpty) {

                      if (_formKey.currentState!.validate()) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isFirstRun', false);
                        await prefs.setString('phoneNum',
                            phoneNumber.isEmpty ? Validation.checkPhoneNum(ageController.text) : Validation.checkPhoneNum(phoneNumber));
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                      }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
