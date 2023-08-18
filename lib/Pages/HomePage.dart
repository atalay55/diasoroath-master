import 'package:flutter/material.dart';
import 'package:Diasoroath/Pages/Tabs/HelpPage.dart';
import 'package:Diasoroath/Pages/Tabs/ReportPage.dart';
import 'Tabs/CameraPage.dart';

class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness==Brightness.dark;
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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.camera)),
                Tab(icon: Icon(Icons.text_snippet)),
                Tab(icon: Icon(Icons.info)),
              ],
            ),
            title: const Text('Diasoroath'),
            backgroundColor:isDark? Colors.white10: Colors.deepPurpleAccent,
          ),
          body:  SafeArea(
            child: TabBarView(
              children: [
                CameraPage(),
                ReportPage(),
                HelpPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
