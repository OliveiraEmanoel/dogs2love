import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'Details_dog.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  Map<String, dynamic> responseDataBreeds = Map();
  Map<String, dynamic> responseDataBreedRandomPicture = Map();

  String breed = '';
  List<String> breedList = List();
  List<String> breedImagesUrl = List();

  final String urlRequestDogBreeds = 'https://dog.ceo/api/breeds/list/all';

  final String urlRequestDogRandomPicture =
      'https://dog.ceo/api/breeds/image/random';

  //do a request to get all dogs breeds and wait for response
  Future<Map> getDogBreeds() async {
    http.Response response = await http.get(urlRequestDogBreeds);
    if(response.statusCode==200){
    responseDataBreeds = json.decode(response.body)['message'];
    responseDataBreeds.forEach((k, v) {

      breedList.add('$k'.toUpperCase());

    });}

    else{ShowError();}
    return responseDataBreeds;
  }

//do a request to get a random picture for the specific breed
  Future<Map> getDogRandomPictures(String dogBreed) async {
    String urlRequestDogBreedPicture =
        'https://dog.ceo/api/breed/$dogBreed/images/random';
    http.Response response = await http.get(urlRequestDogBreedPicture);
    responseDataBreedRandomPicture = json.decode(response.body);
    breedImagesUrl.add(responseDataBreedRandomPicture.values.toString());
    //print(responseDataBreedRandomPicture.values.toString());
    //print(breedImagesUrl.length);
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