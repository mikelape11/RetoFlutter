import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reto/models/rankingModelo.dart';
import 'package:reto/pages/home.dart';
import 'package:reto/globals/globals.dart' as globals;
import 'package:http/http.dart' as http;

class SlidingCard extends StatefulWidget {
  final int id;
  final String name; 
  final String assetName; 
  final String distancia;
  final String tiempo;
  final int length;
  final AsyncSnapshot snapshot;

  const SlidingCard({
    Key key,
    @required this.id,
    @required this.name,
    @required this.assetName,
    @required this.distancia,
    @required this.tiempo,
    @required this.length,
    @required this.snapshot,
  }) : super(key: key);

  @override
  _SlidingCardState createState() => _SlidingCardState();
}

class _SlidingCardState extends State<SlidingCard> {
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
              'images/Rutas/${widget.assetName}',
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _CardContent( //<--replace the Container with CardContent
              id: widget.id,
              name: widget.name,
              distancia: widget.distancia,
              tiempo: widget.tiempo,
              length: widget.length,
              snapshot: widget.snapshot,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatefulWidget {
  
  final int id;
  final String name;
  final String distancia;
  final String tiempo;
  final int length;
  final AsyncSnapshot snapshot;

  const _CardContent({Key key, @required this.id, @required this.name, @required this.distancia,@required this.tiempo, @required this.length,@required this.snapshot})
      : super(key: key);

  @override
  __CardContentState createState() => __CardContentState();
}

 Future<rankingModelo> registrarPuntuacion(int puntos,String usuario_id, String nombre, int aciertos, int fallos, int tiempo, String rutasId) async{
  var Url = "${globals.ipLocal}/ranking/nuevo";
  var response = await http.post(Url,headers:<String , String>{"Content-Type": "application/json"},
  body:jsonEncode(<String , String>{
    "puntos" : puntos.toString(),
    "usuario_id" : usuario_id,
    "nombre": nombre,
    "aciertos": aciertos.toString(),
    "fallos": fallos.toString(),
    "tiempo": tiempo.toString(),
    "rutasId": rutasId
  }));

}

Future<List<rankingModelo>> getRanking() async {
      var data = await http.get('${globals.ipLocal}/ranking/all');
      var jsonData = json.decode(data.body);
      
      List<rankingModelo> rankings = [];
      for (var e in jsonData) {
        rankingModelo ranking = new rankingModelo();
        ranking.usuario_id = e["usuario_id"];
        ranking.nombre = e["nombre"];
        rankings.add(ranking);
      }
      return rankings;
    }

  rankingModelo ranking;

class __CardContentState extends State<_CardContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(widget.name, style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold))
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
                      Text(widget.distancia, style: TextStyle(color: Colors.grey, fontSize: 22)),
                    ],
                  ), 
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("DURACIÓN: ", style: TextStyle(color: Colors.grey, fontSize: 22)),
                      SizedBox(width: 10),
                      Text(widget.tiempo, style: TextStyle(color: Colors.grey, fontSize: 22)),
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
              FutureBuilder(
                future: getRanking(),
                builder: (BuildContext context, AsyncSnapshot snapshot2) {
                  bool noExiste = true;
                if(!snapshot2.hasData){
                    return Center(child: CircularProgressIndicator(strokeWidth: 2));    
                }else{
                return RaisedButton(
                  padding: EdgeInsets.all(10),
                  color: Colors.cyan,
                  child: Text('Vamo a Jugar', style: TextStyle(fontSize: 25),),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () async{
                    for(int i=0; i<widget.snapshot.data.length; i++){
                      if(widget.id == i){
                        globals.idRuta = widget.snapshot.data[i].id;
                      }
                    }
                    for(int i=0; i<snapshot2.data.length; i++){
                      if(snapshot2.data[i].nombre == globals.usuario && snapshot2.data[i].usuario_id == "1"){   
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                          noExiste = false;
                          break;
                      }
                    }
                    if(noExiste){
                      rankingModelo rankings = await registrarPuntuacion(0, "1", globals.usuario, 0, 0, 0, globals.idRuta);
                      setState(() {
                        ranking = rankings;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));  
                    }        
                  },
                );
                }
                }
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}