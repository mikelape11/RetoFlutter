import 'package:flutter/material.dart';
import 'package:reto/pages/home.dart';


class SlidingCard extends StatelessWidget {
  final int id;
  final String name; //<-- title of the event
  final String assetName; //<-- name of the image to be displayed
  final String distancia;
  final String tiempo;
  final int length;

  const SlidingCard({
    Key key,
    @required this.id,
    @required this.name,
    @required this.assetName,
    @required this.distancia,
    @required this.tiempo,
    @required this.length,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), //<--custom shape
      child: Column(
        children: <Widget>[
          ClipRRect(  //<--clipping image
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)), 
            child: Image.asset( //<-- main image
              'images/Rutas/$assetName',
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _CardContent( //<--replace the Container with CardContent
              id: id,
              name: name,
              distancia: distancia,
              tiempo: tiempo,
              length: length,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final int id;
  final String name;
  final String distancia;
  final String tiempo;
  final int length;

  const _CardContent({Key key, @required this.id, @required this.name, @required this.distancia,@required this.tiempo, @required this.length})
      : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(name, style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold))
            ),
          ),
          SizedBox(height: 18),
          Center(
            child: Container(
             
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("DISTANCIA: ", style: TextStyle(color: Colors.grey, fontSize: 22)),
                        SizedBox(width: 10),
                        Text(distancia, style: TextStyle(color: Colors.grey, fontSize: 22)),
                      ],
                    ), 
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("DURACIÓN: ", style: TextStyle(color: Colors.grey, fontSize: 22)),
                        SizedBox(width: 10),
                        Text(tiempo, style: TextStyle(color: Colors.grey, fontSize: 22)),
                      ],
                    ),
                  ],
                ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                padding: EdgeInsets.all(10),
                color: Colors.cyan,
                child: Text('Vamo a Jugar', style: TextStyle(fontSize: 25),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onPressed: () {
                  for(int i=0; i<length; i++){
                    if(id == i){
                      
                    }
                  }
                  
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}