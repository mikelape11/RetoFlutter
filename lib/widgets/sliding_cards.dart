import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reto/models/rutasModelo.dart';
import 'package:reto/widgets/sliding_card.dart';
import 'package:http/http.dart' as http;
import 'package:reto/globals/globals.dart' as globals;


class SlidingCardsView extends StatefulWidget {


  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;


 Future<List<rutasModelo>> getRutas() => Future.delayed(Duration(milliseconds: 500 ), () async {
    var data = await http.get('${globals.ipLocal}/routes/all');
    var jsonData = json.decode(data.body);

    List<rutasModelo> ruta = [];
    for (var n in jsonData) {
      //print(jsonData2);
      rutasModelo rutas = new rutasModelo();
      rutas.id = n["_id"];
      rutas.nombre = n["nombre"];
      rutas.ciudad = n["ciudad"];
      rutas.distancia = n["distancia"];
      rutas.tiempo = n["tiempo"];
      ruta.add(rutas);
      globals.id = n["_id"];
      
    }
    return ruta;
  });
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRutas(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.68,  //<-- set height of the card
            child: PageView(
              controller: pageController,
              children: <Widget>[
                for(int i=0; i<snapshot.data.length; i++)
                  SlidingCard(      
                    id: i,
                    name: '${snapshot.data[i].ciudad}',
                    distancia: "${snapshot.data[i].distancia} KM" ,
                    tiempo: "${snapshot.data[i].tiempo}",
                    assetName: 'donosti2.jpg',
                    length: snapshot.data.length,
                  ),
              ],
            ),
          );
        }else{
          return Container(
            height: 500,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
      }
    );
  }
}
