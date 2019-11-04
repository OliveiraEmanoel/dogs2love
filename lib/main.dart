import 'dart:io';

import 'package:dogs/pages/Home_page.dart';
import 'package:dogs/utilities/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//setting to fixed portrait mode
Future main() async {
 
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    

   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dogs',
        theme: ThemeData(
          primaryIconTheme: IconThemeData(
            color: Colors.red,
          ),
          primarySwatch: Colors.grey,
        ),
        home: HomePage(),);
  }
  

	

}










