
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gokhan/Pages/Tabs/HelpPage.dart';
import 'package:gokhan/Pages/Tabs/ReportPage.dart';
import 'package:gokhan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entity/User.dart';
import 'Tabs/CameraPage.dart';

class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
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
            backgroundColor: Colors.deepPurpleAccent,
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
