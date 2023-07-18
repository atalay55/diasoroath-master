import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gokhan/Pages/LoginPage.dart';
import 'package:gokhan/Services/Validation/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage> {

  Future<String> get() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val =  await prefs.getString('phoneNum');
    return val!;
  }


  Future<void> createUser( String name, String value, String avatarUrl, String smoke, String age) async {
    String phoneNum = await get();
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
  late TextEditingController _nameSurnameController;
  late TextEditingController _ageController;
  late FocusNode _nameFocusNode;
  late FocusNode _ageFocusNode;
  bool _isChecked = false;
  var sexValue = 0;
  var width, height;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameSurnameController = TextEditingController();
    _ageController = TextEditingController();
    _nameFocusNode = FocusNode();
    _ageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameSurnameController.dispose();
    _ageController.dispose();
    _nameFocusNode.dispose();
    _ageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.shortestSide;
    height= MediaQuery.of(context).size.height;
    return Scaffold(

      body:
      GestureDetector(
        onTap: (){
          _nameFocusNode.unfocus();
          _ageFocusNode.unfocus();
        },
        child: Container(
          height: height,/*
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background_image.jpg'),
              fit: BoxFit.cover,
              opacity: 0.9,
            ),
          ),*/
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:  EdgeInsets.only(top: width/7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: EdgeInsets.only(top:0.0),
                        child: Image.asset(
                          'images/Logo.png',
                          width: width/1.5,
                          height: width/2,
                          scale: 1,
                          alignment: Alignment.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:width/12,
                            left: width/15,
                            right:width/15),
                        child: TextFormField(
                          focusNode: _nameFocusNode,
                          style: TextStyle(color: Colors.black),
                          controller: _nameSurnameController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: width/22 ,color: Colors.black),
                            errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 4, color: Colors.red),
                                borderRadius: BorderRadius.circular(25.0)),
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
                            label: Text(
                              "Profile Name",
                              style: TextStyle(fontSize: width/20,color: Colors.black),
                            ),
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                          return  Validation.checkUserName(value!);
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            bottom:width/15,
                            left: width/15,
                            right:width/15),
                        child: TextFormField(
                          style: TextStyle(color:  Colors.black),
                          focusNode: _ageFocusNode,
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: width/22 ,color:  Colors.black),
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
                            label: Text(
                              "Age",
                              style: TextStyle(fontSize:  width/20 ,color: Colors.black),
                            ),
                            fillColor:  Colors.black,
                          ),
                          validator: (value) {
                           return Validation.checkAge(value!);
                          },
                        ),

                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: width/12,bottom:width/30),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Do you smoke ?",
                                style: TextStyle(
                                  fontSize: width/21,
                                  color:  Colors.black
                                ),
                              ),
                              Transform.scale(
                                scale: 1.5,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                  unselectedWidgetColor:  Colors.black87,
                                ),
                                  child: Checkbox(
                                  activeColor: Colors.red,

                               shape:  RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(25), //
                                     ),
                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                  value: _isChecked ,
                                  onChanged: (chacked){
                                    setState(() {
                                      if(_isChecked==null){
                                        print("asdsadsdd");
                                      }
                                      _isChecked=chacked!;
                                      print(_isChecked);
                                    });
                                  },),
                                )),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding:  EdgeInsets.only(left: width/12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Gender:",
                              style: TextStyle(
                                fontSize: width/21,
                                color:  Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.symmetric(horizontal:width/20 ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Transform.scale(
                                scale: 1.2,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:  Colors.black,
                                  ),
                                  child: RadioListTile<int>(

                                    activeColor: Colors.red,
                                    title: Row(
                                      children: [
                                        Text(
                                          "F",
                                          style: TextStyle(fontSize: width / 25, color:  Colors.black),
                                        ),
                                      ],
                                    ),
                                    value: 1,
                                    groupValue: sexValue,
                                    onChanged: (int? veri) {
                                      setState(() {
                                        sexValue = veri!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),


                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:  Colors.black,
                              ),
                              child: Flexible(
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: RadioListTile<int>(
                                    activeColor: Colors.red,
                                    title: Row(
                                      children: [
                                        Text(
                                          "M",
                                          style: TextStyle(fontSize: width / 25, color:  Colors.black),
                                        ),
                                      ],
                                    ),
                                    value: 2,
                                    groupValue: sexValue,
                                    onChanged: (int? veri) {
                                      setState(() {
                                        sexValue = veri!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),

                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:  Colors.black,
                              ),
                              child: Flexible(
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: RadioListTile<int>(
                                    activeColor: Colors.red,
                                    title: Row(
                                      children: [
                                        Text(
                                          "MB",
                                          style: TextStyle(fontSize: width / 25, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    value: 0,
                                    groupValue: sexValue,
                                    onChanged: (int? veri) {
                                      setState(() {
                                        sexValue = veri!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),

                          ],

                        ),
                      ),

                      Center(
                        child: Padding(
                          padding:  EdgeInsets.symmetric(vertical:width/15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(top:width/20),
                                child: SizedBox(
                                  width: width/3.5,
                                  height: width/8.5,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurpleAccent, // Background color
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.yellowAccent,
                                      shape:   RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), //
                                      ),// Text Color (Foreground color)
                                    ),
                                    onPressed: () {

                                      setState(() {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                                      });


                                    },
                                    child: Text('Back',style: TextStyle(fontSize: width/20)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(top:width/20,left: width/5),
                                child: SizedBox(
                                  width: width/3.5,
                                  height: width/8.5,

                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurpleAccent, // Background color
                                      onPrimary: Colors.white,
                                      shape:   RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), //
                                      ),
                                    ),
                                    onPressed: () {

                                      setState(() {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            createUser(_nameSurnameController.text, this.sexValue.toString(), " ", _isChecked.toString(), _ageController.text).then((value) => {
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()))
                                            });
                                          });


                                        }
                                      });

                                    },
                                    child: Text('Submit',style: TextStyle(fontSize: width/20)),
                                  ),
                                ),
                              ),
                            ],

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}


