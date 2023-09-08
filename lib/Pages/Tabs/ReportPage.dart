import 'dart:io';
import 'package:Diasoroath/Services/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:Diasoroath/Entity/Report.dart';
import 'package:Diasoroath/Pages/ReportPageDetail.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  List<int> selectedItems =[];
  late List<Report> selectedReport ;



  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body:FutureBuilder<List<Report>>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text('Veriler alınamadı',),
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
                    snapshot.data![index].ImagePath.replaceAll("'", "").replaceAll("'", ""));

                return GestureDetector(
                  onLongPress: (){
                    selectedReport=[];
                    setState(() {
                      selectedItems.add(index);
                      selectedReport.add(snapshot.data![index]);

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
                                    await ReportUtilities().deleteReport(snapshot.data![index].id);
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

                        await ReportUtilities().shareReportPdf(snapshot.data![index]);
                        setState(() {

                        });
                      }
                    },
                    child: GestureDetector(
                      onTap: () {

                        if(selectedItems.isNotEmpty){
                          setState(() {
                            if(selectedItems.contains(index)){
                              setState(() {
                                selectedItems.remove(index);
                                selectedReport.remove(snapshot.data![index]);
                                print(selectedItems);
                              });
                            }
                            else{
                              setState(() {
                                selectedItems.add(index);
                                selectedReport.add(snapshot.data![index]);

                              });


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
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: isDark?  Colors.white24:Colors.black45, // Change this color to the desired border color
                              width: 3.0, // Adjust the border width as needed
                            ),
                         color:  selectedItems.contains(index) ? Colors.white24 : null,
                            // Add more styling properties if needed
                          ),
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
                                    "Report ${(snapshot.data!.length - index).toString()} ",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                );
              },
            )
                : Center(child: Text("You do not have any report"));
          }
        },
        future:ReportUtilities(). getReport(),
      ),
      floatingActionButton: selectedItems.isNotEmpty ?FloatingActionButton(
        onPressed: () async{

         await ReportUtilities().deleteReports(selectedReport,selectedItems);
         setState(() {

         });
          },
        child: Row(mainAxisAlignment: MainAxisAlignment.center ,crossAxisAlignment: CrossAxisAlignment.center,children: [Icon(Icons.remove), Text(selectedItems.length.toString())],),
      ):null
    );
  }
}
