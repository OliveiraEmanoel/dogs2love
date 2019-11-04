import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsDog extends StatefulWidget {
  final String dogBreed;
  DetailsDog(this.dogBreed);

  @override
  _DetailsDogState createState() => _DetailsDogState();
}

class _DetailsDogState extends State<DetailsDog> {
  List<String> picturesUrl = List();
  List<dynamic> responseBreedPics = List();

  @override
  void initState() {
    super.initState();
    getBreedsPic(widget.dogBreed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.dogBreed.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
                itemCount: picturesUrl.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Image.network(picturesUrl[index]),
                  );
                })));
  }

  Future getBreedsPic(String breed) async {
    http.Response response =
        await http.get('https://dog.ceo/api/breed/${breed}/images');
    if (response.statusCode == 200) {
      setState(() {
        responseBreedPics = (json.decode(response.body)['message']);
      });
      for (int x = 0; x < picturesUrl.length; x++) print(picturesUrl[x]);
    } else {
      throw Exception('Erro carregando fotos');
    }

    responseBreedPics.forEach((v) {
      picturesUrl.add(v);
    });
    print(picturesUrl.length);

  }

  //only works for random images...
  fetchTen() {
    for (int i = 0; i < 10; i++) {
      getBreedsPic(widget.dogBreed);
    }
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
