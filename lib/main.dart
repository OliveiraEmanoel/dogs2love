

import 'dart:io';

import 'package:dogs/pages/Home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//setting to fixed portrait mode
Future main() async {


  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
   runApp(MyApp());

  
}


class MyApp extends StatefulWidget {
 
  @override
  _MyAppState createState() => _MyAppState();

}



class _MyAppState extends State<MyApp> {
  static bool internetConnected;

  @override
  void initState(){
    super.initState();

  }
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
        home: HomePage());
  }


  Future<bool> hasInternet() async {
    bool connected;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        connected = true;
      }
    } on SocketException catch (_) {
      //print('not connected');
      connected = false;
    }
      internetConnected = connected;

    return connected;

  }
}

class ShowError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Text("Sem conexão com a internet!"),
        ));
  }
}








