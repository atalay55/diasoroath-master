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
    var width = MediaQuery.of(context).size.width;
    File file = File(widget.report.ImagePath.replaceAll("'", ""));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diasoroath'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: widget.report.userId == LoginPage.user!.id
          ? Container(
        color: Colors.white12,
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

            Padding(
              padding: EdgeInsets.all(15),
              child: file != null
                  ? Image.file(
                file,
                width: width,
                height: width/1.5,
                fit: BoxFit.fill,
              )
                  : Center(child: CircularProgressIndicator()),
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
                        color: Colors.deepPurpleAccent,
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
                        color: Colors.deepPurpleAccent,
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
                        color: Colors.deepPurpleAccent,
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
                        color: Colors.deepPurpleAccent,
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
