//import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reto/models/rankingModelo.dart';
import 'package:reto/models/rutasDataModelo.dart';
import 'package:reto/models/usuarioModelo.dart';
import 'package:reto/theme/theme.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reto/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:reto/bloc/mapa/mapa_bloc.dart';

import 'package:reto/widgets/widgets.dart';
import 'package:reto/pages/perfil_usuario.dart';

import '../bloc/mapa/mapa_bloc.dart';
import '../models/rankingModelo.dart';
import '../models/rutasModelo.dart';
import '../widgets/custom_alert_dialog.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:http/http.dart' as http;
import 'package:reto/globals/globals.dart' as globals;



//import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {

  //PANTALLA HOME
  @override
    Home createState()=> Home();
  }

class Home extends State<HomePage> with WidgetsBindingObserver{
  GoogleMapController _controller;

  PickedFile _imageFile; //PARA LA FOTO DE PERFIL
  MapType _currentMapType = MapType.normal;
  List<ChatMessage> mensajes = [];

  @override
  void initState() { //LLAMO A LA FUNCION DE INICIAR SEGUIMIENTO DEL USUARIO DEL MAPA
  // ignore: deprecated_member_use
    context.bloc<MiUbicacionBloc>().iniciarSeguimiento();
    WidgetsBinding.instance.addObserver(this);
    // _loadMapStyles();
    super.initState();
  }

  Future<List<rankingModelo>> getRanking() async {
    var data = await http.get('http://10.0.2.2:8080/ranking/all');
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
      rankings.rutas_id = e["rutas_id"];
      ranking.add(rankings);
    }
    return ranking;
  }

  Future<List<usuarioModelo>> getAvatar() async {
    var data = await http.get('http://10.0.2.2:8080/usuarios/todos');
    var jsonData = json.decode(data.body);

    List<usuarioModelo> usuario = [];
    for (var e in jsonData) {
      usuarioModelo usuarios = new usuarioModelo();
      usuarios.avatar = e["avatar"];
      usuario.add(usuarios);
    }
    return usuario;
  }

  Future<List<rutasModelo>> getRutasData() async {
    var data = await http.get('http://10.0.2.2:8080/routes/all');
    var jsonData = json.decode(data.body);
    // print(jsonData);
    List<rutasModelo> datos = [];
    for (var e in jsonData) {
      rutasModelo rutas = new rutasModelo();
      print("nn ${e["rutas_data"]}");
      var list = e['rutas_data'] as List;
      rutas.rutas_data =  list.map((i) => rutasDataModelo.fromJson(i)).toList();
      print("aaaaa $rutas");
      datos.add(rutas);
    }
    return datos;
  }


  @override
  void dispose() { //LLAMO A LA FUNCION DE CANCELAR SEGUIMIENTO DEL USUARIO DEL MAPA
  // ignore: deprecated_member_use
    context.bloc<MiUbicacionBloc>().cancerlarSeguimiento();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget crearMapa(MiUbicacionState state){ //FUNCION DONDE CREO EL MAPA
    
    if( !state.existeUbicacion ) return Center(child: CircularProgressIndicator(strokeWidth: 2));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));

    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 15,
    );

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      mapType: _currentMapType,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      onMapCreated: (GoogleMapController controller){ 
        Theme.of(context).primaryColor == Colors.grey[900] ? mapaBloc.initMapa(controller) : mapaBloc.initMapa2(controller);
        _controller = controller;
      },
      polylines: mapaBloc.state.polylines.values.toSet(),
      onCameraMove: (cameraPosition){
        mapaBloc.add(OnMovioMapa(cameraPosition.target));
      },

    );
  }

  Widget button(Function function){
    return Container(
      alignment: FractionalOffset.bottomRight,
      margin: EdgeInsets.only(top: 330, right: 10),
      child: CircleAvatar(
        maxRadius: 28,
        backgroundColor: Colors.cyan,
        child: CircleAvatar(
          maxRadius: 25,
          child: IconButton(
            icon: Icon( Icons.satellite_outlined),
            onPressed: function,
          ),
        ),
      )
    );
  }

  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
      ? MapType.satellite
      : MapType.normal;
    });
  }

  Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
    if(Theme.of(context).primaryColor == Colors.grey[900]) {
      return Icon(Icons.bedtime_outlined);
    } else {
      return Icon(Icons.wb_sunny_outlined);
    }
  }

  changeMapMode(){
    if(Theme.of(context).primaryColor == Colors.grey[900]){
      getJsonFile("images/map_styles/light.json").then(setMapStyle);
    }else{
      getJsonFile("images/map_styles/dark.json").then(setMapStyle);
    }
  }

  Future<String> getJsonFile(String path)async{
   return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle){
    _controller.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA
    final List<Widget> children = _widgetOptions(); //LA FUNCION PARA LA NAVEGACION DE LA PANTALLA HOME(CHAT, MAPA, RANKING)
    return new Scaffold( //EMPIEZA LA PANTALLA DEL REGISTRO
      appBar: AppBar(
         leading: FutureBuilder(
          future: getRutasData(),
          builder: (BuildContext context, AsyncSnapshot snapshot2) {
          return FutureBuilder(
            future: getUsuarios(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            for(int i=0; i<snapshot.data.length; i++)
              if(snapshot.data[i].usuario == globals.usuario && snapshot.data[i].avatar == "images/perfil.png"){
                  globals.existeAvatar = true;
                    break;
              }else{
                  globals.existeAvatar = false;
              }
            return Center(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Theme.of(context).primaryColor == Colors.grey[900] ? Colors.cyan : Colors.black,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: globals.existeAvatar
                        ? AssetImage("images/perfil.png") 
                        : FileImage(File(globals.avatar))
                      )            
                    ),
                  ],
                )
              ),
        );
        }
        );
        }
         ),
        automaticallyImplyLeading: false,
        title: Text("HOME"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            // onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark()),
            onPressed: () { 
              changeMapMode();
              Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark());
              setState(() {});
            },
          ),
          IconButton( //ICONO PARA IR AL PERFIL DE USUARIO
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PerfilUsuario(),
              ));
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container( //TODA LA PANTALLA DEL HOME
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [ 
                Container(
                  //child: _widgetOptions.elementAt(_selectedIndex),
                  child: children[_selectedIndex], //SE VERA EN PANTALLA LA OPCION SELECCIONADA DEL BOTTOMNAVIGATIONBAR
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar( //LAS OPCIONES DEL BOTTOMNAVIGATIONBAR
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Ranking',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
  
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  List<Widget> _widgetOptions() => [
    Column( //PANTALLA MAPA
      children: [
        Stack( //ES COMO POSITION ABSOLUTE PARA COLOCAR LOS BOTONES
          children: <Widget>[
            Container( //CONTAINER DEL MAPA
              height: 600,
              child: BlocBuilder<MiUbicacionBloc, MiUbicacionState>( //PARA USAR LOS BLOCS CREADOS PARA LA GESTION DEL MAPA (UBICACION)
                builder: ( _ , state) => crearMapa(state) //LLAMO A LA FUNCION DEL MAPA
              ),
            ),
            Column( //COLOCACION DE TODOS LOS BOTONES
              children: <Widget>[
                button(_onMapTypeButtonPressed),
                //BtnTipoMapa(),
                BtnLineaRuta(),
                BtnSeguirUbicacion(),
                BtnUbicacion(),
              ],
            ),
          ]
        ),
      ],
    ), //LAS OPCIONES DEL B
    Center(
      child: Container( //PANTALLA CHAT (POR HACER)
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container( 
              child: DashChat(
                // messageDecorationBuilder: (ChatMessage msg, bool isUser) {
                //   return BoxDecoration(
                //     color: Theme.of(context).primaryColor == Colors.grey[900] ? Colors.white70 : Colors.black87
                //   );
                // },
                messageContainerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Theme.of(context).primaryColor == Colors.grey[900] ? Colors.grey[900] : Colors.cyan[300],
                ),
                inputContainerStyle: BoxDecoration(        
                  color: Theme.of(context).primaryColor == Colors.grey[900] ? Colors.grey[900] : Colors.grey[300],
                  border: Border.all(color: Colors.cyan, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                height: MediaQuery.of(context).size.height/1.4,
                user: ChatUser( 
                  name: "Jhon Doe",
                  uid: "xxxxxxxxx",
                  // avatar:
                  //     "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
                ),
                messages: mensajes,
                // messages: [ ChatMessage(
                //   text: "Hello",
                //   user: ChatUser(
                //     containerColor: Colors.cyan,
                //     name: "Fayeed",
                //     uid: "123456789",
                //     avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
                //   ),
                //   createdAt: DateTime.now(),
                // )],
                onSend: (ChatMessage) {
                  mensajes.add(ChatMessage);
                },
              ),
            ),
            // messageListArea(), //EL CONTAINER DE LOS MENSAJES
            // submitArea(), //EL CONTAINER PARA ENVIAR LOS MENSAJES
          ],
        )
      ),
    ),
    FutureBuilder(
      future: getUsuarios(),
      builder: (BuildContext context, AsyncSnapshot snapshot2) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: FutureBuilder(
          future: getRanking(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot2.hasData){
            return Container(
              height: 600,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }else{
          List<int> puntuaciones = [];
          List<int> puntuacionesOrdenadas = [];
          List<String> nombres = [];
          List<String> fotos = [];
          for(int i=0; i<snapshot.data.length; i++){
            puntuaciones.add(snapshot.data[i].puntos);
          }  
          puntuaciones.sort(); 
          puntuaciones.reversed;
          puntuacionesOrdenadas.addAll(puntuaciones.reversed);
          for(int n=0; n<puntuacionesOrdenadas.length; n++){
            for(int m=0; m<snapshot.data.length; m++){
              if(puntuacionesOrdenadas[n] == snapshot.data[m].puntos){
                nombres.add(snapshot.data[m].nombre);
              }
            }
          }     
          print(nombres);
          for(int k=0;k<nombres.length;k++){
            for(int j=0;j<puntuacionesOrdenadas.length;j++){
              if(nombres[k] == snapshot2.data[j].usuario){
                fotos.add(snapshot2.data[j].avatar);
              }
            }
          }
          print(fotos);
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
                            for(int n=0; n<puntuacionesOrdenadas.length;n++)
                              if(puntuacionesOrdenadas[1] == snapshot.data[n].puntos)
                            GestureDetector(
                                onTap: () {
                                  detalles(context, snapshot.data[n].nombre, snapshot);
                                },
                               child: Text(
                                '${snapshot.data[n].nombre}',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                            for(int n=0; n<puntuacionesOrdenadas.length;n++)
                              if(puntuacionesOrdenadas[1] == snapshot.data[n].puntos)
                            Text(
                              '${snapshot.data[n].puntos}',
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
                            for(int n=0; n<puntuacionesOrdenadas.length;n++)
                              if(puntuacionesOrdenadas[2] == snapshot.data[n].puntos)
                            GestureDetector(
                              onTap: () {
                                  detalles(context, snapshot.data[n].nombre, snapshot);
                                },
                              child: Text(
                                '${snapshot.data[n].nombre}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                             for(int n=0; n<puntuacionesOrdenadas.length;n++)
                              if(puntuacionesOrdenadas[2] == snapshot.data[n].puntos)
                            Text(
                              '${snapshot.data[n].puntos}',
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
                          for(int n=0; n<puntuacionesOrdenadas.length;n++)
                            if(puntuacionesOrdenadas[0] == snapshot.data[n].puntos)
                            GestureDetector(
                               onTap: () {
                                  detalles(context, snapshot.data[n].nombre, snapshot);
                                },
                              child: Text(
                                '${snapshot.data[n].nombre}',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            for(int n=0; n<puntuacionesOrdenadas.length;n++)
                              if(puntuacionesOrdenadas[0] == snapshot.data[n].puntos)
                            Text(
                              '${snapshot.data[n].puntos}',
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
                    for(int n=3; n<puntuacionesOrdenadas.length;n++)//HACE FALTA HACER UN FOR PARA TODOS LOS JUGADORES
                    GestureDetector(
                      onTap: () {
                        detalles(context, nombres[n], snapshot);
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
                                  color: Colors.grey[900],
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
                                '${nombres[n]}', 
                                style: TextStyle(
                                  fontFamily: 'arial',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                )
                              )
                            ),
                            Container( //PUNTUACION
                              margin: EdgeInsets.only(left: 15),
                              width: 50,
                              height: 40, 
                              alignment: Alignment.center,
                              child: Text(
                                '${puntuacionesOrdenadas[n]}', 
                                style: TextStyle(
                                  fontFamily: 'arial',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
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
    )
  ];

  void _onItemTapped(int index) { //FUNCION PARA SELECCIONAR LA PANTALLA DE LOS 3 DIFERENTES QUE EXISTEN
    setState(() {
      _selectedIndex = index;
    });
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
                    // child: Text(
                    //   'Route Quest trata sobre un juego de preguntas sobre localizaciones especificas de nuestras rutas personalizadas para aquellos que desean conocer o visitar ciertos lugares del mundo. \n\nAparte de conocer lugares nuevos, podrás competir contra otros usuarios e incluso chatear con ellos.',
                    //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    // ),
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
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}