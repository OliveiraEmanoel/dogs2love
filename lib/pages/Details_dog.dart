import 'dart:convert';
import 'dart:io';

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
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<String> tempList = List(); // = picturesUrl.sublist(0,5);
  int _listOffset = 0;
  int _listLimit = 10;
  bool internetState=false;




  @override
  void initState() {
    super.initState();
    hasInternet();
    getBreedsPic(widget.dogBreed);
    
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
        _listLimit += 5;
        _listOffset = _listLimit + 1;

        tempList
          ..addAll(
              List<String>.from(picturesUrl.sublist(_listOffset, _listLimit)));

        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                controller: _scrollController,
                itemCount: picturesUrl.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == picturesUrl.length) {
                    return _buildProgressIndicator();
                  } else {
                    return Card(
                      child: Image.network(picturesUrl[index]),
                    );
                  }
                })));
  }

     //checa se existe conexÃƒÂ£o com a internet
	Future hasInternet() async {
		bool connected;
		try {
			final result = await InternetAddress.lookup('google.com');
			if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
				// print('connected');
				connected = true;
        internetState=true;
			}
		} on SocketException catch (_) {
			//print('not connected');
			connected = false;
		}
		print("Internet = $connected");

mostraAlerta();

   
	
	}

  void mostraAlerta(){
if(!internetState){
     showDialog (
      context: context,
      builder: (_)=>AlertDialog(
      title: Text('Aviso'),
      content: Text('Verifique sua conexão com a internet!'),
      actions: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(16))),
          child: FlatButton(
            
            onPressed: (){exit(0);},
            child: Text('OK',style: TextStyle(
              color: Colors.white,
              
              fontWeight: FontWeight.bold),),
          ),
        )
      ],
      elevation: 16,
      backgroundColor: Colors.white,
      //shape: CircleBorder(),
      )
        
      
      
    );
   }

  }
	

  Future getBreedsPic(String breed) async {
    //mostraAlerta();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    http.Response response =
        await http.get('https://dog.ceo/api/breed/$breed/images');
    if (response.statusCode == 200) {
      setState(() {
        responseBreedPics = (json.decode(response.body)['message']);
      });
      //for (int x = 0; x < picturesUrl.length; x++) print(picturesUrl[x]);

    } else {
      throw Exception('Erro carregando fotos');
    }

    responseBreedPics.forEach((v) {
      picturesUrl.add(v);
    });

    setState(() {
      isLoading = false;
    });
    print(picturesUrl.length);
  }

  

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Opacity(
            opacity: isLoading ? 1.0 : 00,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
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
