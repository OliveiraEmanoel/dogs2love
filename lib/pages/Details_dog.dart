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
 
  bool isLoading = false;
  List<String> tempList = List(); // = picturesUrl.sublist(0,5);
  int _indexActual = 0;
  int _itemsPerPage = 10;
  bool loaded = false;
  bool internetState=false;




  @override
  void initState() {
    super.initState();
    hasInternet();//checking internet connection
    getBreedsPic(widget.dogBreed);//loading pictures for this breed
     
      
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
                
                itemCount: (_indexActual <= picturesUrl.length) ? tempList.length + 1 : tempList.length,//picturesUrl.length + 1,
                itemBuilder: (BuildContext context, int index) {
                 print("Indice = $index");       
                 print(tempList.length); 
                 print(picturesUrl.length);  
                // print(_indexActual);      
                  return (index == tempList.length)?

                     Container(
                       height: 50,
                      color: Colors.greenAccent,
                      child:  Center(
                        child: (tempList.length==0)? Text("Carregando fotos...",
                        style:TextStyle(fontSize: 20,)):
                        (tempList.length==picturesUrl.length)?Text('Final do arquivo',
                            style:TextStyle(fontSize: 20,)):
                         FlatButton(
                          child: Text("Clic aqui para mais fotos...",
                              style:TextStyle(fontSize: 20,)),
                          onPressed: () {
                            
                            setState(() {
                              if((_indexActual + _itemsPerPage)> picturesUrl.length) {
                                tempList.addAll(
                                    picturesUrl.getRange(_indexActual, picturesUrl.length));
                              } else {
                               tempList.addAll(
                                    picturesUrl.getRange(_indexActual,_indexActual + _itemsPerPage));
                              }
                              _indexActual = _indexActual + _itemsPerPage;
                            });
                          },
                        ),
                      ),
                    ):
                     Card(
                      child: Image.network(tempList[index]),
                    );
                  
                })));
  }

     //check if has a valid internet connection
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

    } else {
      throw Exception('Erro carregando fotos');
    }

    responseBreedPics.forEach((v) {
      picturesUrl.add(v);//has all pictures for this breed
      
    });

    setState(() {//loading the first ten pictures
      if (picturesUrl.length < 10 ){
        tempList.addAll(picturesUrl.getRange(_indexActual,picturesUrl.length));
         _indexActual = _indexActual + picturesUrl.length;
        }else{
        tempList
          ..addAll(picturesUrl.getRange(_indexActual, _indexActual + _itemsPerPage));
        _indexActual = _indexActual + _itemsPerPage;
     
      isLoading = false;}
    });
    print(picturesUrl.length);
  }



//  Widget _buildProgressIndicator() {
//    return Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Container(
//        child: Center(
//          child: Opacity(
//            opacity: isLoading ? 1.0 : 00,
//            child: CircularProgressIndicator(),
//          ),
//        ),
//      ),
//    );
//  }


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
