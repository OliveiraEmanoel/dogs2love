import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Details_dog.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> responseDataBreeds = Map();

  Map<String, dynamic> responseDataBreedRandomPicture = Map();
  bool internetState=false;
  String breed = '';

  List<String> breedList = List();

  List<String> breedImagesUrl = List();

  final String urlRequestDogBreeds = 'https://dog.ceo/api/breeds/list/all';

  final String urlRequestDogRandomPicture =
      'https://dog.ceo/api/breeds/image/random';

  var listener;



  @override
  void initState() {
    super.initState();
    hasInternet();
  }


  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  Future<Map> getDogBreeds() async {
   // hasInternet();
    print('$internetState  getting dogs..');
    http.Response response = await http.get(urlRequestDogBreeds);
    if (response.statusCode == 200) {
      responseDataBreeds = json.decode(response.body)['message'];
      responseDataBreeds.forEach((k, v) {
        breedList.add('$k'.toUpperCase());
      });
    } else {
      ShowError();
    }
    return responseDataBreeds;
  }



  //check if has a valid internet connection
  Future hasInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          mostrarAlerta();
          break;
      }
    });
      return await DataConnectionChecker().connectionStatus;

  }

  Future<Map> getDogRandomPictures(String dogBreed) async {
    String urlRequestDogBreedPicture =
        'https://dog.ceo/api/breed/$dogBreed/images/random';
    http.Response response = await http.get(urlRequestDogBreedPicture);
    responseDataBreedRandomPicture = json.decode(response.body);
    breedImagesUrl.add(responseDataBreedRandomPicture.values.toString());

    return responseDataBreedRandomPicture;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.black12, Colors.grey[200]]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Image.asset('assets/images/logo2.png'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                exit(0);
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30,
              ),
            )
          ],
        ),
        body: Container(
          child: FutureBuilder<Map>(
            future: getDogBreeds(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return ShowError();
              return snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: responseDataBreeds.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                final String _detailsPageTitle =
                                    breedList[index].toLowerCase();
                                gotoPagina(
                                    context, DetailsDog(_detailsPageTitle));
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    breedList[index],
                                    style: TextStyle(
                                        fontSize: 21, color: Colors.black),
                                  ),
                                  subtitle: Text(
                                      responseDataBreeds.keys.elementAt(index),
                                      style: TextStyle(color: Colors.white)),
                                  leading: Image.asset(
                                      'assets/images/pet_friendly.png'),
                                ),
                              ),
                            );
                          }),
                    )
                  : Center(child: new CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }



  gotoPagina(BuildContext context, Widget pagina) {
    Route route = MaterialPageRoute(builder: (context) => pagina);
    Navigator.push(context, route);
  }

   mostrarAlerta(){

   return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Aviso'),
          content: Text('Verifique sua conexão com a internet!'),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: FlatButton(
                onPressed: () {
                  exit(0);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
          elevation: 16,
          backgroundColor: Colors.white,
          //shape: CircleBorder(),
        ));
  }
}



class ShowError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text("Erro carrregando dados!"),
    ));
  }
}
