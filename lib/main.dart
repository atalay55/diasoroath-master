import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gokhan/Pages/HomePage.dart';
import 'package:gokhan/Pages/LoginPage.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
 var ageController =TextEditingController();
 String phoneNumber = '';
  Future<void> getPhoneNumber() async {
    if (await Permission.contacts.isGranted) {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null && contact.phones != null && contact.phones!.isNotEmpty) {
        setState(() {
          phoneNumber = contact.phones!.first.value!;
          ageController.text = phoneNumber;
        });
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
          setState(() {
            phoneNumber = contact.phones!.first.value!;
          });
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
    final FocusNode phoneNumberFocusNode = FocusNode();
    var width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(

      appBar: AppBar(
         title: Text('Diasoroath'),
         backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: width/8, horizontal: width/20),
              child: Text(
                'Please enter phone number',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: width/15,
                  left: width/15,
                  right: width/15),
              child: TextFormField(
                focusNode: phoneNumberFocusNode,
                style: TextStyle(color: Colors.black),
                controller: ageController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: width/22, color: Colors.yellowAccent),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(width: 4, color: Colors.red),
                    borderRadius: BorderRadius.circular(25.0),),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 4, color: Colors.red),
                      borderRadius: BorderRadius.circular(25.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 4, color: Colors.purpleAccent),
                      borderRadius: BorderRadius.circular(25.0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 4, color: Colors.green),
                      borderRadius: BorderRadius.circular(25.0)),
                  label:Text( phoneNumber.isNotEmpty?"${phoneNumber}":"Phone number",style: TextStyle(color: Colors.black),),
                  hintText: "${phoneNumber}",hintStyle: TextStyle(color: Colors.black),

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
                  }
                  return null;
                },
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent, // Background color
                onPrimary: Colors.white,
                shape:   RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), //
                ),
              ),
              child: Text('Select Phone ',style: TextStyle(fontSize: width/20),),
              onPressed: ()async {
                 await getPhoneNumber() ;}
            ),
            Padding(
              padding:  EdgeInsets.only(top: width/15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent, // Background color
                  onPrimary: Colors.white,
                  shape:   RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), //
                  ),
                ),
                child: Text('Send' ,style: TextStyle(fontSize: width/20),),
                onPressed: () async {
                  print(ageController.text);
                  if (ageController.text.isNotEmpty || phoneNumber.isNotEmpty) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isFirstRun', false);
                    await prefs.setString('phoneNum',phoneNumber.isEmpty ? ageController.text:phoneNumber );
                    setState(() {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                    });

                  }
                },
              ),
            ),
          ],
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
