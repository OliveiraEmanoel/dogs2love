import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey,Colors.grey[200]]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
            body: SafeArea(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            
                            color: Colors.black,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top:24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              
                              children: <Widget>[
                                Image.asset('assets/images/logo2.png'),
                                Container(
                                  height:500,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    itemCount:10 ,
                                    itemBuilder: (context,index){
                                      return ListTile(
                                        title: Text('teste'),
                                      );

                                    },
                                  ),
                                )
                                
                              ],
                            ),
                          ),
          
        ),
        
            ),
            
      ),
    );
  }
}