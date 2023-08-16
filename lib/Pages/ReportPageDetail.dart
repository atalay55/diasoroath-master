import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gokhan/Entity/Report.dart';
import 'package:gokhan/Pages/LoginPage.dart';

class ReportPageDetail extends StatefulWidget {
  Report report;
  ReportPageDetail(this.report);

  @override
  State<ReportPageDetail> createState() => _ReportPageDetailState();
}

class _ReportPageDetailState extends State<ReportPageDetail> {
  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
    var width = MediaQuery.of(context).size.width;
    File file = File(widget.report.ImagePath.replaceAll("'", ""));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diasoroath'),
        toolbarHeight: width/5,
        backgroundColor:isDark? Colors.white10: Colors.deepPurpleAccent,
      ),
      body: widget.report.userId == LoginPage.user!.id
          ? Container(
        color: Colors.white12,
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Adjust the radius value as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Match the radius here
                child: file != null
                    ? Image.file(
                  file,
                  width: width,
                  height: width / 1.5,
                  fit: BoxFit.cover,
                )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: 'Age: ',
                      style: TextStyle(
                        color: isDark? Colors.white70: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: '${LoginPage.user!.age}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: 'Smoke: ',
                      style: TextStyle(
                        color: isDark? Colors.white70: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: '${LoginPage.user!.smoke}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: 'Gender: ',
                      style: TextStyle(
                        color: isDark? Colors.white70: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: '${LoginPage.user!.gender}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8,
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(
                      text: 'Do you have any sick: ',
                      style: TextStyle(
                        color: isDark? Colors.white70: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    TextSpan(
                      text: '${widget.report.reportDetail}',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
          )
          : Text("Oppss there is an error! Try again"),
    );
  }
}
