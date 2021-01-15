import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reto/models/rutasModelo.dart';
import 'package:reto/widgets/sliding_card.dart';
import 'package:http/http.dart' as http;

class SlidingCardsView extends StatefulWidget {


  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;


 Future<List<rutasModelo>> getRutas() async {
    var data = await http.get('http://10.0.2.2:8080/routes/all');
    var jsonData = json.decode(data.body);

    List<rutasModelo> ruta = [];
    for (var n in jsonData) {
      //print(jsonData2);
      rutasModelo rutas = new rutasModelo();
      rutas.nombre = n["nombre"];
      rutas.ciudad = n["ciudad"];
      rutas.distancia = n["distancia"].toString();
      rutas.tiempo = n["tiempo"].toString();
      ruta.add(rutas);
      
    }
    return ruta;
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRutas(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.68,  //<-- set height of the card
        child: PageView(
          controller: pageController,
          children: <Widget>[
            for(int i=0; i<snapshot.data.length; i++)
            SlidingCard(
              name: '${snapshot.data[i].ciudad}',
              date: '3 Horas',
              distancia: "${snapshot.data[i].distancia}",
              tiempo: "${snapshot.data[i].tiempo}",
              assetName: 'donosti2.jpg',
            ),
          ],
        ),
      );
      }
    );
  }
}
