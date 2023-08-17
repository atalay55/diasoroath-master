import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gokhan/Pages/HomePage.dart';
import 'package:gokhan/Pages/RegisterPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Entity/User.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  static User ? user;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var nameCont= TextEditingController();
  var imageCont= TextEditingController();
  late List<User> users = [];
  late  File? imageFile= null;


  Future<String> get() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val =  await prefs.getString('phoneNum');
    return val!;
  }

  Future<List<User>> getUsers() async {
     users.clear();
    String phone =await get();
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

    return  this.users;
  }


  Future<void> updateDocument(String userId, String updatedValue) async {
     String phoneNum = await get();

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
    String phone =await get();
    CollectionReference userCollectionRef = FirebaseFirestore.instance.collection(phone);
    DocumentReference documentReference = userCollectionRef.doc(user.id);

    await documentReference.delete().then((value) {
      print('Veri silindi.');
    }).catchError((error) {
      print('Silme işlemi başarısız oldu: $error');
    });


  }


  Future<File> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
      }
    });
    print(imageFile);
    return imageFile!;
  }


  @override
  Widget build(BuildContext context) {
    final isDark= MediaQuery.of(context).platformBrightness == Brightness.dark;
    var width = MediaQuery.of(context).size.shortestSide;
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.only(top: width/12),
            child: isDark ?Image.asset(
              'images/logo1.png',
              alignment: Alignment.center,
              scale: 1,
              height: width/1.6,
            ):Image.asset(
              'images/Logo.png',
              alignment: Alignment.center,
              scale: 1,
            ),
          ),
          Flexible(
            child: FutureBuilder<List<User>>(
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Veriler alınamadı'),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                          });
                        }, child: Text("Register"))
                      ],
                    ));
                  }
                  else if (snapshot.data == null) {
                    return   GestureDetector(
                        child: Container(
                          width: width/5,
                          height: width/5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              SizedBox(height: width/50),
                              Text(
                                "Add user",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                          });
                        }
                    );
                  }
                  else {
                    users = snapshot.data!;

                    return  Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            itemCount: snapshot.data!.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {

                              File img= File(users[index].avatarUrl.replaceAll("'", "").replaceAll("File:", "").replaceAll(" ", ""));

                              return GestureDetector(
                                onTap: (){
                                  LoginPage.user=users[index];
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                                },
                                onLongPress: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text('Do you want to delete the user?'),
                                          content:Form(
                                            child:ElevatedButton(child:Text("Delete"),onPressed: (){
                                              setState(() {
                                                deleteUser(users[index]);
                                                Navigator.pop(context);
                                              });

                                            }) ,
                                          )
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:  EdgeInsets.all(8),
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(

                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 3,color:  isDark?  Colors.white24: Colors.black45),

                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onLongPress: () async{
                                            await _pickImageFromGallery().then((value) {
                                                setState(() {
                                                  updateDocument(  users[index].id, value.toString());});
                                                });

                                          },

                                          child: Container(
                                            decoration: BoxDecoration(

                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: img.toString() == "File: ''"
                                                  ? Image.asset(
                                                "images/img_${index > 8 ? index % 8 : index % 3}.png",
                                                width: width / 3.5,
                                                height: width / 3.5,
                                                fit: BoxFit.fill,
                                              )
                                                  : Image.file(
                                                img,
                                                width: width / 3.5,
                                                height: width / 3.5,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),


                                        SizedBox(height:width/25),
                                        Text(
                                          users[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width/25,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              );
                            },
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: width/50,right: width/50,bottom: width/100),
                          child: GestureDetector(
                              child: Container(
                                width: width/5,
                                height: width/5,

                                decoration: BoxDecoration(
                                  color:isDark? null: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 2 ,color: Colors.white24),

                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center ,
                                  children: [
                                    Icon(Icons.add,color: Colors.white,size: 35,),

                                  ],
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                                });
                              }
                          ),
                        ),
                      ],
                    );

                  }
                }
            ),
          ),

        ],
      ),
    );



  }


}
