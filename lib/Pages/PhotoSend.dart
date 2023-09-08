import 'dart:async';
import 'dart:io';
import 'package:Diasoroath/Services/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:Diasoroath/Pages/HomePage.dart';
import 'package:Diasoroath/Pages/LoginPage.dart';
import 'package:lottie/lottie.dart';

import '../Services/API/SendPhotoToAPI.dart';


class PhotoSend extends StatelessWidget {
   final File imageFile;
   PhotoSend({required this.imageFile });

   late String reportId =" ";



   @override
  Widget build(BuildContext context) {
     final isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
     final double width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: width/5,
        backgroundColor:isDark? Colors.white10: Colors.deepPurpleAccent,
        title: Text('Diasoroath'),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: Image.file(
                imageFile,
                width: 1800,
                height: 1800,
                fit: BoxFit.fill,

              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                //padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.only(
                    left: 25,
                    bottom:30,
                    right: 25
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: width/10,
                      width: width/4,
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                        },
                        child: Text('RETURN'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            isDark? Colors.white:
                            Colors.deepPurpleAccent, // Set the desired color
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: width/10,
                      width: width/5,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text('By sending a photo, you automatically accept our Terms&Services. Do you agree?'),
                                  content:Form(
                                    child:ElevatedButton(child:Text("Yes") ,style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(
                                   isDark?Colors.white70:Colors.deepPurpleAccent,

                                    )
                                    ),onPressed: ()async{

                                       showDialog(
                                         context: context,
                                         builder: (BuildContext context) {

                                          ReportUtilities().addReport(LoginPage.user!.id,"", this.imageFile.toString().replaceFirst("File: ", ""),reportId).then((value) {

                                             SendPhotoToAPI(imageFile,LoginPage.user!.name,reportId);
                                           });
                                           Timer(Duration(seconds:2), () {
                                             Navigator.of(context).pop();// Close
                                           });

                                           return AlertDialog(
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(35), // Adjust the radius value as needed
                                             ),
                                               title: Column(
                                                 children: [
                                                   Text("Waiting Response"),
                                                  Lottie.asset("asset/okey.json"),
                                             ],
                                               ),
                                           );
                                         },
                                       );
                                       Timer(Duration(seconds:2), () {
                                         Navigator.of(context).pop();// Close
                                       });
                                    }
                                    ) ,
                                  )
                              );
                            },
                          );
                       Timer(Duration(seconds:3), () {  Navigator.pop(context);});
                        },

                        child: Text('SEND'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            isDark? Colors.white:
                            Colors.deepPurpleAccent, // Set the desired color
                          ),
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
    );
  }
}


