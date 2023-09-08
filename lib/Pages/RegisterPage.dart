import 'package:Diasoroath/Services/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:Diasoroath/Pages/LoginPage.dart';
import 'package:Diasoroath/Services/Validation/validation.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {

  late TextEditingController _nameSurnameController;
  late TextEditingController _ageController;
  late FocusNode _nameFocusNode;
  late FocusNode _ageFocusNode;
  bool _isChecked = false;
  var sexValue = 0;
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


    return Scaffold(
      body: GestureDetector(
        onTap: (){
          _nameFocusNode.unfocus();
          _ageFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:  EdgeInsets.only(top: Utilities().width/7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: EdgeInsets.only(top:0.0, bottom: Utilities().width/15),
                      child:Utilities().isPlatformDarkMode ?Image.asset(
                        'images/logo1.png',
                        alignment: Alignment.center,
                        scale: 1,
                        height: Utilities().width/1.7,
                      ):Image.asset(
                        'images/Logo.png',
                        alignment: Alignment.center,
                        scale: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom:Utilities().width/12,
                          left: Utilities().width/15,
                          right:Utilities().width/15),
                      child: TextFormField(
                        focusNode: _nameFocusNode,
                        controller: _nameSurnameController,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: Utilities().width/22 ),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.red),
                              borderRadius: BorderRadius.circular(15.0)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.red),
                              borderRadius: BorderRadius.circular(15.0)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Utilities().isPlatformDarkMode? Colors.white:Colors.black87),
                            borderRadius: BorderRadius.circular(15.0),),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                 width: 2, color: Colors.green),
                              borderRadius: BorderRadius.circular(15.0)),
                          label: Text(
                            "Profile Name",
                            style: TextStyle(fontSize: Utilities().width/20),
                          ),

                        ),
                        validator: (value) {
                        return  Validation.checkUserName(value!);
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          bottom:Utilities().width/15,
                          left: Utilities().width/15,
                          right:Utilities().width/15),
                      child: TextFormField(
                        focusNode: _ageFocusNode,
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: Utilities().width/22 ),
                          errorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.red),
                              borderRadius: BorderRadius.circular(15.0),),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.red),
                              borderRadius: BorderRadius.circular(15.0)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Utilities().isPlatformDarkMode? Colors.white:Colors.black87),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Colors.green),
                              borderRadius: BorderRadius.circular(15.0)),
                          label: Text(
                            "Age",
                            style: TextStyle(fontSize:  Utilities().width/20 ),
                          ),

                        ),
                        validator: (value) {
                         return Validation.checkAge(value!);
                        },
                      ),

                    ),

                    Padding(
                      padding:  EdgeInsets.only(left: Utilities().width/12,bottom:Utilities().width/30),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Do you smoke ?",
                              style: TextStyle(
                                fontSize: Utilities().width/21,

                              ),
                            ),
                            Transform.scale(
                              scale: 1.5,
                              child: Theme(
                                data: Theme.of(context).copyWith(

                              ),
                                child: Checkbox(
                                activeColor: Utilities().isPlatformDarkMode? Colors.white:Colors.black54,checkColor: Utilities().isPlatformDarkMode? Colors.black87:Colors.white ,

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
                      padding:  EdgeInsets.only(left: Utilities().width/12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Gender:",
                            style: TextStyle(
                              fontSize: Utilities().width/21,
                            ),
                          ),
                        ],
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:Utilities().width/20 ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Transform.scale(
                              scale: 1.2,
                              child: Theme(
                                data: Theme.of(context).copyWith(

                                ),
                                child: RadioListTile<int>(

                                  activeColor: Utilities().isPlatformDarkMode? Colors.white:Colors.black87,
                                  title: Row(
                                    children: [
                                      Text(
                                        "F",
                                        style: TextStyle(fontSize: Utilities().width / 25),
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

                            ),
                            child: Flexible(
                              child: Transform.scale(
                                scale: 1.2,
                                child: RadioListTile<int>(
                                  activeColor: Utilities().isPlatformDarkMode? Colors.white:Colors.black87,
                                  title: Row(
                                    children: [
                                      Text(
                                        "M",
                                        style: TextStyle(fontSize: Utilities().width / 25),
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

                            ),
                            child: Flexible(
                              child: Transform.scale(
                                scale: 1.2,
                                child: RadioListTile<int>(
                                  activeColor: Utilities().isPlatformDarkMode? Colors.white:Colors.black87,
                                  title: Row(
                                    children: [
                                      Text(
                                        "NB",
                                        style: TextStyle(fontSize: Utilities().width / 25),
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
                        padding:  EdgeInsets.symmetric(vertical:Utilities().width/15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top:Utilities().width/20),
                              child: SizedBox(
                                width: Utilities().width/3.5,
                                height: Utilities().width/8.5,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Utilities().isPlatformDarkMode ? Colors.white10 :Colors.deepPurpleAccent, // Background color
                                    onPrimary: Colors.white,

                                    shape:   RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15), //
                                    ),//
                                  ),
                                  onPressed: () {

                                    setState(() {
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                                    });


                                  },
                                  child: Text('Back',style: TextStyle(fontSize: Utilities().width/20)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:Utilities().width/20,left: Utilities().width/5),
                              child: SizedBox(
                                width: Utilities().width/3.5,
                                height: Utilities().width/8.5,

                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Utilities().isPlatformDarkMode ? Colors.white10 :Colors.deepPurpleAccent, // Background color
                                    onPrimary: Colors.white,
                                    shape:   RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15), //
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await RegisterUtilities().createUser(_nameSurnameController.text, sexValue.toString(), " ", _isChecked.toString(), _ageController.text);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                    }
                                  },
                                  child: Text('Submit',style: TextStyle(fontSize: Utilities().width/20)),
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

    );
  }
}


