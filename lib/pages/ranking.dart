import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reto/models/rankingModelo.dart';
import 'package:reto/models/rutasModelo.dart';
import 'package:reto/models/rutasLocalizacionModelo.dart';
import 'package:reto/models/rutasDataModelo.dart';
import 'package:reto/pages/menu_ruta.dart';
import 'package:reto/pages/perfil_usuario.dart';
import 'package:reto/theme/theme.dart';
import 'package:reto/widgets/custom_alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:reto/globals/globals.dart' as globals;
import 'package:reto/pages/login.dart';

class rankingPage extends StatefulWidget {
  rankingPage({Key key}) : super(key: key);

  @override
  _rankingPageState createState() => _rankingPageState();
}

class _rankingPageState extends State<rankingPage> {

  Future<List<rankingModelo>> getRanking() async {
    var data = await http.get('${globals.ipLocal}/ranking/ordenado');
    var jsonData = json.decode(data.body);

    List<rankingModelo> ranking = [];
    for (var e in jsonData) {
      rankingModelo rankings = new rankingModelo();
      rankings.id = e["_id"];
      rankings.puntos = e["puntos"];
      rankings.usuario_id = e["usuario_id"];
      rankings.nombre = e["nombre"];
      rankings.aciertos = e["aciertos"];
      rankings.fallos = e["fallos"];
      rankings.tiempo = e["tiempo"];
      rankings.rutasId = e["rutasId"];
      ranking.add(rankings);
    }
    return ranking;
  }

  Future<List<rutasModelo>> getRutasData() async {
    var data = await http.get('${globals.ipLocal}/routes/all');
    var jsonData = json.decode(data.body);
    
    List<rutasModelo> datos = [];
    for (var e in jsonData) {
      rutasModelo rutas = new rutasModelo();
      rutas.id = e["id"];
      var list = e['rutas_data'] as List;
      rutas.rutas_data =  list.map((i) => rutasDataModelo.fromJson(i)).toList();
      var list2 = e['rutas_loc'] as List;
      rutas.rutas_loc =  list2.map((i) => rutasLocalizacionModelo.fromJson(i)).toList();
      datos.add(rutas);
    }
    return datos;
  }

  Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
    if(Theme.of(context).primaryColor == Colors.grey[900]) {
      return Icon(Icons.bedtime_outlined);
    } else {
      return Icon(Icons.wb_sunny_outlined);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA
    return new Scaffold(
      appBar: AppBar(
        leading:  IconButton( //ICONO PARA IR AL PERFIL DE USUARIO
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MenuRuta(),
              ));
            }
          ),
        automaticallyImplyLeading: false,
        title: Text("HOME"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            onPressed: () { 
              Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark());
              setState(() {});
            },
          ),
         
          IconButton( //ICONO PARA IR AL PERFIL DE USUARIO
            icon: Icon(Icons.login_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
      child: FutureBuilder(
      future: getUsuarios(),
      builder: (BuildContext context, AsyncSnapshot snapshot2) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: FutureBuilder(
              future: getRanking(),
              builder: (BuildContext context, AsyncSnapshot snapshot5) {
                if(!snapshot2.hasData){
                  return Container(
                    height: 600,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }else{
                List<String> fotos = [];
                List<int> listaRankingPuntos = [];
                List<String> listaRankingNombres = [];

              //guardar los puntos
                for(int i=0; i<snapshot5.data.length;i++){
                  listaRankingPuntos.add(snapshot5.data[i].puntos);
                }
              //guardar los nombres
                for(int i=0; i<snapshot5.data.length;i++){
                  listaRankingNombres.add(snapshot5.data[i].nombre);
                }
              
              //guardar los avatars
                for(int k=0;k<listaRankingNombres.length;k++){
                  for(int j=0;j<listaRankingPuntos.length;j++){
                    if(listaRankingNombres[k] == snapshot2.data[j].usuario){
                      fotos.add(snapshot2.data[j].avatar);
                    }
                  }
                }
                return Column(
                  children: <Widget>[ 
                    Divider(),
                    Text( //TEXTO DEL TITULO DE LA PANTALLA
                      'CLASIFICACIÓN',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Container( //CONTAINER DEL PODIO
                      padding: EdgeInsets.only(bottom: 5),
                      margin: EdgeInsets.only(top: 0),
                      child: Row( //LAS 3 POSICIONES IRAN EN UNA FILA
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack( //PARA PODER COLOCAR LOS CONTAINERS DENTRO DE LA FILA
                          children: [
                            Container( //ESTRELLA 1
                              margin: EdgeInsets.symmetric(horizontal: 137),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amberAccent[400],
                                    size: 60.0,
                                  ),
                                  Text(
                                    '1', 
                                    style: TextStyle(
                                      fontFamily: 'arial',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Colors.grey[900],
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container( //ESTRELLA 2
                              margin: EdgeInsets.only(left: 30, top: 70),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.blueGrey[300],
                                    size: 60.0,
                                  ),
                                  Text(
                                    '2', 
                                    style: TextStyle(
                                      fontFamily: 'arial',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Colors.grey[900],
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container( //ESTRELLA 3
                              margin: EdgeInsets.only(left: 245, top: 80),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.brown,
                                    size: 60.0,
                                  ),
                                  Text(
                                    '3', 
                                    style: TextStyle(
                                      fontFamily: 'arial',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                      color: Colors.grey[900],
                                    )
                                  )
                                ],
                              ),
                            ),  
                            Container( //FOTO SEGUNDA POSICION
                              margin: EdgeInsets.only(left: 0, top: 110),
                              child: GestureDetector(
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor: Colors.blueGrey[300],
                                  child: CircleAvatar(
                                    radius: 56.0,
                                    backgroundImage: fotos[1] == "images/perfil.png"
                                      ? AssetImage("images/perfil.png") 
                                      : FileImage(File(fotos[1]))
                                  )            
                                ),
                              ),
                            ),
                            Container( //FOTO TERCERA POSICION
                              margin: EdgeInsets.only(left: 214, top: 120),
                              child: GestureDetector(
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor: Colors.brown,
                                  child: CircleAvatar(
                                    radius: 56.0,
                                    backgroundImage: fotos[2] == "images/perfil.png"
                                      ? AssetImage("images/perfil.png") 
                                      : FileImage(File(fotos[2]))
                                  )            
                                ),
                              ),
                            ),
                            Container( //FOTO PRIMERA POSICION
                              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 84),
                              child:  GestureDetector(
                                child: CircleAvatar(
                                  radius: 83,
                                  backgroundColor: Colors.amberAccent[400],
                                  child: CircleAvatar(
                                    radius:  79,
                                    backgroundImage: fotos[0] == "images/perfil.png"
                                      ? AssetImage("images/perfil.png") 
                                      : FileImage(File(fotos[0]))
                                  )            
                                ),
                              ),
                            ),
                            Container( //NOMBRE SEGUNDA POSICION
                              color:  Colors.blueGrey[300],
                              padding: EdgeInsets.symmetric(vertical: 11),
                              width: 110,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 239, left: 5),
                              child: Column(
                                children: [
                                      GestureDetector(
                                          onTap: () {
                                            detalles(context, listaRankingNombres[1], snapshot5);
                                          },
                                        child: Text(
                                          '${listaRankingNombres[1]}',
                                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                          
                                        ),
                                      ),
                                      Text(
                                        '${listaRankingPuntos[1]}',
                                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                      ),
                                ],
                              ),
                            ),
                            Container( //NOMBRE TERCERA POSICION
                              color: Colors.brown,
                              padding: EdgeInsets.symmetric(vertical: 7),
                              width: 110,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 249, left: 220),
                              child: Column(
                                children: [
                                      GestureDetector(
                                        onTap: () {
                                            detalles(context, listaRankingNombres[2], snapshot5);
                                          },
                                        child: Text(
                                          '${listaRankingNombres[2]}',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),

                                      Text(
                                        '${listaRankingPuntos[2]}',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                ],
                              ),
                            ),
                            
                            Container( //NOMBRE PRIMERA POSICION
                              color: Colors.amberAccent[400],
                              padding: EdgeInsets.symmetric(vertical: 20),
                              width: 120,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 219, left: 108),
                              child: Column(
                                children: [
                                      GestureDetector(
                                        onTap: () {
                                            detalles(context, listaRankingNombres[0], snapshot5);
                                          },
                                        child: Text(
                                          '${listaRankingNombres[0]}',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        '${listaRankingPuntos[0]}',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                ],
                              ),
                            ),         
                          ],
                        ), 
                      ])
                    ),
                    Divider(),           
                    Container( //CONTENEDOR PARA LOS OTROS PUESTOS
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          for(int n=3; n<listaRankingPuntos.length;n++)//HACE FALTA HACER UN FOR PARA TODOS LOS JUGADORES
                          GestureDetector(
                            onTap: () {
                              detalles(context, listaRankingNombres[n], snapshot5);
                            },
                            child: Container( //CONTAINER PARA LOS DATOS DEL JUGADOR
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 10),
                              child: Row( //CREO UNA FILA PARA MOSTRARLOS
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container( //NUMERO POSICION
                                    width: 40,
                                    height: 40,
                                    color: Colors.cyan,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${n+1}', 
                                      style: TextStyle(
                                        fontFamily: 'arial',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: listaRankingNombres[n] == globals.usuario ? Colors.red [900] : Colors.grey[900],
                                      )
                                    )
                                  ),
                                  Container( //FOTO 
                                    margin: EdgeInsets.only(left: 14),
                                    width: 70,
                                    height: 40,
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.cyan,
                                      child: CircleAvatar(
                                        radius: 19.0,
                                        backgroundImage: fotos[n] == "images/perfil.png"
                                      ? AssetImage("images/perfil.png") 
                                      : FileImage(File(fotos[n]))
                                      )            
                                    ),
                                  ),
                                  Container( //NOMBRE DEL USUARIO
                                    margin: EdgeInsets.only(left: 13),
                                    width: 132,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${listaRankingNombres[n]}', 
                                      style: TextStyle(
                                        fontFamily: 'arial',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: listaRankingNombres[n] == globals.usuario ? Colors.red [900] : Theme.of(context).primaryColor == Colors.grey[900] ? Colors.white : Colors.black,
                                      )
                                    )
                                  ),
                                  Container( //PUNTUACION
                                    margin: EdgeInsets.only(left: 15),
                                    width: 50,
                                    height: 40, 
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${listaRankingPuntos[n]}', 
                                      style: TextStyle(
                                        fontFamily: 'arial',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: listaRankingNombres[n] == globals.usuario ? Colors.red [900] : Theme.of(context).primaryColor == Colors.grey[900] ? Colors.white : Colors.black,
                                      )
                                    )
                                  ),
                                ]
                              ),
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ],
                );
                }
              }
            )
          );
      }
    ),
       )
    );
  }

  void detalles(BuildContext context, String usuario, AsyncSnapshot snapshot) {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        contentPadding: EdgeInsets.all(5),
        content: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan, width: 4),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.6,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container( //Respuesta1
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'DETALLES',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.cyan),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container( 
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: <Widget>[
                          Text('Nombre', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('Puntuacion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('Duracion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('Aciertos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('Fallos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(width: 35,),
                      for(int i=0;i<snapshot.data.length;i++)
                        if(snapshot.data[i].nombre == usuario)
                      Column(
                        children: <Widget>[
                          Text('${usuario}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('${snapshot.data[i].puntos}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('${snapshot.data[i].tiempo}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('${snapshot.data[i].aciertos}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('${snapshot.data[i].fallos}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}