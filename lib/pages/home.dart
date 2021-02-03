//import 'dart:async';

import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reto/models/datosGlobalesModelo.dart';
import 'package:reto/models/rankingModelo.dart';
import 'package:reto/models/rutasDataModelo.dart';
import 'package:reto/models/usuarioModelo.dart';
import 'package:reto/models/ubicacionModelo.dart';
import 'package:reto/models/rutasLocalizacionModelo.dart';
import 'package:reto/models/preguntasModelo.dart';
import 'package:reto/models/preguntasRespuestasModelo.dart';
import 'package:reto/pages/finalizar.dart';
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

import 'perfil_usuario.dart';

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
  Set<Circle> _circles = HashSet<Circle>();
  Set<Marker> _markers = HashSet<Marker>();
  bool _isVisible1 = false;
  bool _isVisible2 = false;
  bool _isVisible3 = false;
  bool _isVisible4 = false;
  bool _isVisible5 = false;
  bool _isVisible6 = false;
  bool _isVisible7 = false;
  final Set<Polyline> _polyline = {};
  List<LatLng> listaRutas = List();
  List<LatLng> listaMarkers = List();
  List<LatLng> listaUbicaciones = List();
  List<int> posicionesPreguntas = [];
  List<String> preguntas = [];

  Position _currentPosition;
  List<int> posiciones;
  var guardarIdMarker = '';
  List<String> respuestas1 = [];
  List<String> respuestas2 = [];
  List<String> respuestas3 = [];
  List<String> respuestas4 = [];
  List<String> respuestas5 = [];
  List<String> respuestas6 = [];
  List<String> respuestas7 = [];
  int contador = 0;
  int contador2 = 0;
  int contador3 = 0;
  int cont = 0;
  List<rankingModelo> ranking = [];
  Position ubicacionUsuario;
  var variableGlobal;

  bool markerVisible1 = false;
  bool markerVisible2 = false;
  bool markerVisible3 = false;
  bool markerVisible4 = false;
  bool markerVisible5 = false;
  bool markerVisible6 = false;
  bool markerVisible7 = false;

 @override
  void initState() { 
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    WidgetsBinding.instance.addObserver(this);
    _distanceFromCircle();
    setState((){});
    recibirMensaje();
    setState((){});
    //globals.socket.listen((data) => escucharServer(utf8.decode(data)));
    super.initState();
  }

  void recibirMensaje() async{
      await globals.socket.listen((data) => escucharServer(utf8.decode(data)));
      globals.conectado = true;
    
  }

  void escucharServer(json){
    var datos = jsonDecode(json);
    print(datos);
    setState(() {
      //if(datos["route"] == globals.idRuta){
        print("hola");
        globals.mensajes.add(ChatMessage(
          buttons: [Text(datos["value"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)],
          text: datos["from"], 
          user: ChatUser(
            //containerColor: Theme.of(context).primaryColor == Colors.grey[900] ? Colors.cyan : Colors.red,
            color: Colors.cyan,
            name: datos["from"],
            uid: datos["from"],
          ) 
        ));
      //}
    });
    print(globals.mensajes);
  }

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
      rankings.aciertos = e["globals.aciertos"];
      rankings.fallos = e["globals.fallos"];
      rankings.tiempo = e["tiempo"];
      rankings.rutasId = e["rutasId"];
      ranking.add(rankings);
    }
    return ranking;
  }

  Future<rankingModelo> actualizarRanking(rankingModelo ranking) async{
    var Url = "${globals.ipLocal}/ranking/actualizar";
    var response = await http.put(Url,headers:<String , String>{"Content-Type": "application/json"},
    body: jsonEncode(ranking));
  }



  Future<List<usuarioModelo>> getAvatar() async {
    var data = await http.get('${globals.ipLocal}/usuarios/todos');
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
    var data = await http.get('${globals.ipLocal}/routes/all');
    var jsonData = json.decode(data.body);
    
    List<rutasModelo> datos = [];
    for (var e in jsonData) {
      rutasModelo rutas = new rutasModelo();
      rutas.id = e["_id"];
      var list = e['rutas_data'] as List;
      rutas.rutas_data =  list.map((i) => rutasDataModelo.fromJson(i)).toList();
      var list2 = e['rutas_loc'] as List;
      rutas.rutas_loc =  list2.map((i) => rutasLocalizacionModelo.fromJson(i)).toList();
      datos.add(rutas);
    }
    return datos;
  }

  Future<List<preguntasModelo>> getPreguntas(String rutaId) async {
    var data = await http.get('${globals.ipLocal}/preguntas/${rutaId}');
    var jsonData = json.decode(data.body);

    List<preguntasModelo> datos = [];
    for (var e in jsonData) {
      preguntasModelo preguntas = new preguntasModelo();
      preguntas.id = e["id"];
      preguntas.numPregunta = e["numPregunta"];
      preguntas.pregunta = e["pregunta"];
      var list = e['respuestas'] as List;
      preguntas.respuestas =  list.map((i) => preguntasRespuestasModelo.fromJson(i)).toList();
      preguntas.rutasId = e["rutasId"];
      preguntas.opcion = e["opcion"];
      datos.add(preguntas);
    }
    return datos;
  }

  Future<List<ubicacionModelo>> getUbicaciones() async {
    var data = await http.get('${globals.ipLocal}/ubicacion/todos');
    var jsonData = json.decode(data.body);

    List<ubicacionModelo> datos = [];
    for (var e in jsonData) {
      ubicacionModelo ubicacion = new ubicacionModelo();
      ubicacion.id = e["_id"];
      ubicacion.nombreUsuario = e["nombreUsuario"];
      ubicacion.lat = e["lat"];
      ubicacion.lng =  e["lng"];
      ubicacion.rutaId = e["rutaId"];
      datos.add(ubicacion);
    }
    return datos;
  }

  Future<http.Response> deleteUbicacion(String nombreUsuario) async {
   final http.Response response = await http.delete(
    "${globals.ipLocal}/ubicacion/eliminarPorNombre/${nombreUsuario}",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

    return response;
  }

  Future<ubicacionModelo> registrarUbicacion(String id, String nombreUsuario, double lat, double lng, String rutaId) async{
    var Url = "${globals.ipLocal}/ubicacion/nuevo";
    var response = await http.post(Url,headers:<String , String>{"Content-Type": "application/json"},
    body:jsonEncode(<String , String>{
      "_id" : id,
      "nombreUsuario" : nombreUsuario,
      "lat" : lat.toString(),
      "lng": lng.toString(),
      "rutaId" : rutaId,
    }));
  }

  Future<ubicacionModelo> actualizarUbicacion(ubicacionModelo ubicacion) async{
    var Url = "${globals.ipLocal}/ubicacion/actualizar";
    var response = await http.put(Url,headers:<String , String>{"Content-Type": "application/json"},
    body: jsonEncode(ubicacion));
  }


  @override
  void dispose() { //LLAMO A LA FUNCION DE CANCELAR SEGUIMIENTO DEL USUARIO DEL MAPA
  // ignore: deprecated_member_use
    context.bloc<MiUbicacionBloc>().cancerlarSeguimiento();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<Position> _localizacionUsuario() async {
    return Future((){
      return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    });
  }

  ubicacionModelo ubicacion = new ubicacionModelo();
  void cogerUbicacion(AsyncSnapshot snapshot) async{
    ubicacionUsuario = await _localizacionUsuario();
    double latitude = ubicacionUsuario.latitude;
    double longitud = ubicacionUsuario.longitude;
    String nombreUsuario = globals.usuario;

    for(int i=0;i<snapshot.data.length;i++){
      if(snapshot.data[i].usuario == globals.usuario){
        globals.idUsuario = snapshot.data[i].id;
      }
    }
    ubicacionModelo ubicaciones = await registrarUbicacion(globals.idUsuario, nombreUsuario, latitude, longitud, globals.idRuta);
    ubicacion = ubicaciones;
    
  }

  


  ubicacionModelo ubicacion2 = new ubicacionModelo();
  void actualizarUbicacionUsuario(AsyncSnapshot snapshot) async{
    ubicacionModelo ubi = new ubicacionModelo();
    ubicacionUsuario = await _localizacionUsuario();

    for(int i=0;i<snapshot.data.length;i++){
      if(snapshot.data[i].usuario == globals.usuario){
        globals.idUsuario = snapshot.data[i].id;
      }
    }
    ubi.id =  globals.idUsuario;
    ubi.nombreUsuario = globals.usuario;
    ubi.lat = ubicacionUsuario.latitude;
    ubi.lng = ubicacionUsuario.longitude;
    ubi.rutaId = globals.idRuta;
    ubicacionModelo ubicaciones = await actualizarUbicacion(ubi);
    ubicacion2 = ubicaciones;
    
  }

  Future<List<LatLng>> devolverUbicacionesUsuarios(AsyncSnapshot snapshot) async{
    List<double> rutasLat = [];
    List<double> rutasLng = [];
    for(int n=0; n<snapshot.data.length;n++){
      if(snapshot.data[n].rutaId == globals.idRuta && snapshot.data[n].nombreUsuario != globals.usuario){
          rutasLat.add(snapshot.data[n].lat);
          rutasLng.add(snapshot.data[n].lng);
      }   
    }  
    for(int m=0;m<rutasLat.length;m++){
      LatLng data$m = LatLng(rutasLat[m], rutasLng[m]);
      listaUbicaciones.add(data$m);
    }
    return listaUbicaciones;
  }

  
  Future<void> _distanceFromCircle() async {
    _currentPosition = await _localizacionUsuario();
    for (var circulo in Set.from(_circles)) {
      var distancia = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        circulo.center.latitude,
        circulo.center.longitude);
      // if ((distancia < 50) && (_isVisible1 == false) && (_isVisible2 == false) && (_isVisible3 == false) && (_isVisible4 == false) && (_isVisible5 == false) && (_isVisible6 == false) && (_isVisible7 == false)){
      if (distancia < 50) {
        if(circulo.circleId == CircleId("0")){
      
          markerVisible1 = true;
   
        }else if(circulo.circleId == CircleId("1")){
         
            markerVisible2 = true;
    
        }else if(circulo.circleId == CircleId("2")){
       
            markerVisible3 = true;
       
        }else if(circulo.circleId == CircleId("3")){
          
            markerVisible4 = true;
         
        }else if(circulo.circleId == CircleId("4")){
           markerVisible5 = true;
      
        }else if(circulo.circleId == CircleId("5")){
      
            markerVisible6 = true;
    
        }else if(circulo.circleId == CircleId("6")){
            markerVisible7 = true;
       
        }       
      

        break;
      } else {

          markerVisible1 = false;
          markerVisible2 = false;
          markerVisible3 = false;
          markerVisible4 = false;
          markerVisible5 = false;
          markerVisible6 = false;
          markerVisible7 = false;
      
      }

    }
    //Timer.periodic(new Duration(seconds: 5), (timer) {
      _distanceFromCircle();
    //});
  }

  void _setMarkers() async {
    // String _iconImage = 'images/interrogacion2.png';
    // final bitmapIcon = await BitmapDescriptor.fromAssetImage(
    //       ImageConfiguration(devicePixelRatio: 5), _iconImage);
    setState(() {
      for(int i=0; i<listaMarkers.length;i++){
        _circles.add(Circle(
          strokeWidth: 1,
          strokeColor: Colors.cyan,
          circleId: CircleId("${i}"),
          center: listaMarkers[i],
          radius: 15,       
        ));
      }  
    
      for(int i=0; i<listaMarkers.length;i++){
        guardarIdMarker = '${i}';
        _markers.add(Marker(
        onTap: () {
          if(markerVisible1){
          setState(() {  
            _isVisible1 = true;
            });
          }else if(markerVisible2){
          setState(() {  
            _isVisible2 = true;
            });
          }else if(markerVisible3){
          setState(() {  
            _isVisible3 = true;
            });
          }else if(markerVisible4){
          setState(() {  
            _isVisible4 = true;
            });
          }else if(markerVisible5){
          setState(() {  
            _isVisible5 = true;
            });
          }else if(markerVisible6){
          setState(() {  
            _isVisible6 = true;
            });
          }else if(markerVisible7){
          setState(() {  
            _isVisible7 = true;
            });
          }
        },
        //visible: markerVisible1,
        //icon: bitmapIcon,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan
        ),
        markerId: MarkerId(guardarIdMarker),
        position: listaMarkers[i],
        consumeTapEvents: false));
      }
    
      for(int i=0; i<listaUbicaciones.length;i++){
      _markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed
        ),
        markerId: MarkerId("e${i}"),
        position: listaUbicaciones[i],
        consumeTapEvents: false));
      } 
    });
  }

  Widget crearMapa(MiUbicacionState state){ //FUNCION DONDE CREO EL MAPA
    if( !state.existeUbicacion ) return Center(child: CircularProgressIndicator(strokeWidth: 2));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));

    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 17,
    );

    _polyline.add(Polyline(
      polylineId: PolylineId('line1'),
      visible: true,
      points: listaRutas,
      width: 2,
      color: Colors.cyan,
    ));

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
      polylines: _polyline,
      onCameraMove: (cameraPosition){
        mapaBloc.add(OnMovioMapa(cameraPosition.target));
      },
      circles: _circles,
      markers: _markers,
    );
  }

  Widget button(Function function){
    return Container(
      alignment: FractionalOffset.bottomRight,
      margin: EdgeInsets.only(top: 400, right: 10),
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

  Future<List<LatLng>> devolverLista(AsyncSnapshot snapshot2) async{
    List<double> rutasLat = [];
    List<double> rutasLng = [];
    for(int n=0; n<snapshot2.data.length;n++){
      if(snapshot2.data[n].id == globals.idRuta){
        for(int m=0; m<snapshot2.data[n].rutas_data.length;m++){
          rutasLat.add(snapshot2.data[n].rutas_data[m].lat);
          rutasLng.add(snapshot2.data[n].rutas_data[m].lng);
        }      
      }   
    }  
    for(int m=0;m<rutasLat.length;m++){
        LatLng data$m = LatLng(rutasLat[m], rutasLng[m]);
        listaRutas.add(data$m);
    }
    return listaRutas;
  }

 Future<List<LatLng>> devolverLista2(AsyncSnapshot snapshot2) async{
    List<double> rutasLat2 = [];
    List<double> rutasLng2 = [];
    for(int n=0; n<snapshot2.data.length;n++){
      if(snapshot2.data[n].id == globals.idRuta){
        for(int m=0; m<snapshot2.data[n].rutas_loc.length;m++){
          rutasLat2.add(snapshot2.data[n].rutas_loc[m].lat);
          rutasLng2.add(snapshot2.data[n].rutas_loc[m].lng);
        } 
      }   
    }  
    for(int m=0;m<rutasLat2.length;m++){
      LatLng data$m = LatLng(rutasLat2[m], rutasLng2[m]);
      listaMarkers.add(data$m);
    }
    return listaMarkers;
  }
  
  @override
  Widget build(BuildContext context) {
    
    variableGlobal = Provider.of<DatosGlobales>(context);
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA
    final List<Widget> children = _widgetOptions(); //LA FUNCION PARA LA NAVEGACION DE LA PANTALLA HOME(CHAT, MAPA, RANKING)
    
    return new Scaffold( //EMPIEZA LA PANTALLA DEL REGISTRO
      appBar: AppBar(
      leading: FutureBuilder(
        future: getRutasData(),
        builder: (BuildContext context, AsyncSnapshot snapshot2){
            if(!snapshot2.hasData){
              return Center(child: CircularProgressIndicator(strokeWidth: 2));             
            }else{ 
              //print("HOLA 1");
          return FutureBuilder(
          future: getUbicaciones(),
          builder: (BuildContext context, AsyncSnapshot snapshot3){
             if(!snapshot3.hasData){
              return Center(child: CircularProgressIndicator(strokeWidth: 2));             
            }else{ 
               //print("HOLA 2");
            return FutureBuilder(
            future: getUsuarios(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(strokeWidth: 2),
              );
              }else{
                 //print("HOLA 3");
                  
                 if(contador == 0){
                  devolverLista(snapshot2);
                  devolverLista2(snapshot2);
                  devolverUbicacionesUsuarios(snapshot3);                            
                  cogerUbicacion(snapshot);  
                  _setMarkers(); 
                  contador++;
                }
               
                Timer.periodic(new Duration(seconds: 5), (timer) {
                  actualizarUbicacionUsuario(snapshot);
                });
              
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
              }
            );
            }
          }
          );
            }
          }
      ),       
        automaticallyImplyLeading: false,
        title: Text("HOME"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
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
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
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
  // Future<List<preguntasModelo>> getPreguntas(globals.idRuta);
  // Future<List<rankingModelo>> getRanking();

  List<Widget> _widgetOptions() => [
   //LAS OPCIONES DEL B
    FutureBuilder(
      future: getRanking(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {  
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(strokeWidth: 2));
        }else{
          for(int i=0; i<snapshot.data.length;i++){
            if(snapshot.data[i].nombre == globals.usuario && snapshot.data[i].rutasId == globals.idRuta){
              globals.idRanking = snapshot.data[i].id;
            }
          }
          
        return Center(
        child: Container( //PANTALLA CHAT (POR HACER)
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container( 
                child: DashChat(                
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
                    name: globals.usuario,
                    uid: globals.idUsuario,
                    // avatar:
                    //     "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
                  ),
                  messages: globals.mensajes,      
                  onSend: (ChatMessage) {
                    var mensajeUsuario = Map();
                    mensajeUsuario["action"] = "msg";
                    mensajeUsuario["from"] = globals.usuario;
                    mensajeUsuario["route"] = globals.idRuta;
                    mensajeUsuario["value"] = ChatMessage.text;
                    globals.mensajes.add(ChatMessage);
                    globals.socket?.write("${jsonEncode(mensajeUsuario)}\n");
                  },
                ),
              ),
              // messageListArea(), //EL CONTAINER DE LOS MENSAJES
              // submitArea(), //EL CONTAINER PARA ENVIAR LOS MENSAJES
            ],
          )
        ),
      );
        }
      }
    ),
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
                  Visibility(
                    visible: _isVisible1,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){    
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                        }else{ 
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[0].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) {  
                                                  if(!snapshot4.hasData){    
                                                    return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                  }else{ 
                                                    for(int i=0; i<snapshot4.data.length;i++){
                                                      if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                        globals.idRanking = snapshot4.data[i].id;
                                                      }
                                                    } 
                                                  return Container( //Respuesta1
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[0].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                      setState(() async {
                                                          if(snapshot3.data[0].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;  
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                              
                                                             setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible1 = false;
                                                            }); 
                                                                                                                                                                         
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                         
                                                           setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                          });
                                                            _isVisible1 = false;
                                                                                                                  
                                                          }
                                                                                                                                                   
                                                      },
                                                    );
                                                      })
                                                  );
                                                }
                                                }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                    
                                                  return Container( //Respuesta2
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[0].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[0].opcion == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);  
                                                            setState(() {                                                     
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible1 = false;
                                                            });
                                                           
                                                       
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                         
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible1 = false;
                                                            });
                                                        
                                                          }
                                                        });
                                                      },
                                                    )
                                                  );
                                                  }
                                                  }
                                                
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[0].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[0].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                   
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible1 = false;
                                                            });
                                                       
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                  
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible1 = false;
                                                            });
                                                        
                                                          }
                                                        });
                                                      },
                                                        
                                                    )
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            ); 
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisible2,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){   
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));          
                                        }else{          
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[1].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                               FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[1].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[1].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible2 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                       
                                                            ranking = rankings as List<rankingModelo>;
                                                            setState(() {
                                                              _isVisible2 = false;
                                                            });
                                                          
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                      
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible2 = false;
                                                            });
                                                         
                                                          }
                                                      
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[1].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[1].opcion  == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible2 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                       
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible2 = false;
                                                            });
                                                         
                                                          }else{
                                                           print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                     
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible2 = false;
                                                            });
                                                        
                                                          }
                                                     
                                                      },
                                                    );
                                                      })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[1].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[1].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible2 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                  
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible2 = false;
                                                            });
                                                       
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                      
                                                            setState(() {
                                                            ranking = rankings as List<rankingModelo>;
                                                              _isVisible2 = false;
                                                            });
                                                          
                                                          }
                                                     
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            );                                     
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisible3,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){ 
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));            
                                        }else{                
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[2].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                               FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[2].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[2].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible3 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;                                                         
                                                              _isVisible3 = false;
                                                            });
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                          
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible3 = false;
                                                            });                                                      
                                                          }
                                                      
                                                      },
                                                    );
                                                      })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[2].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[2].opcion == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible3 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                 
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible3 = false;
                                                            });
                                                      
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                          
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible3 = false;
                                                            });
                                                       
                                                          }
                                                     
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                 FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[2].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () async {
                                                        setState(() async {
                                                          if(snapshot3.data[2].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible3 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                     
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible3 = false;
                                                            });
                                                      
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                      
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible3 = false;
                                                            });
                                                        
                                                          }
                                                      
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            );                                      
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisible4,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){      
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));       
                                        }else{
                                                                   
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[3].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[3].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[3].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible4 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                  
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible4 = false;
                                                            });
                                                         
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                   
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible4 = false;
                                                            });
                                                         
                                                          }
                                                       
                                                      },
                                                    );
                                                      })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                               FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[3].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[3].opcion == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible4 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                        
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible4 = false;
                                                            });
                                                         
                                                          }else{
                                                           print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                      
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible4 = false;
                                                            });
                                                       
                                                          }
                                                  
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                               FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[3].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[3].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible4 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                         
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible4 = false;
                                                            });
                                                      
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                     
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible4 = false;
                                                            });
                                                      
                                                          }
                                                   
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            );                                      
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisible5,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){  
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));           
                                        }else{                                   
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[4].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[4].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[4].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible5 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                     
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible5 = false;
                                                            });
                                                         
                                                          }else{
                                                           print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                         
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible5 = false;
                                                            });
                                                      
                                                          }
                                                 
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                               FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[4].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[4].opcion == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible5 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible5 = false;
                                                            });
                                                         
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                  
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible5 = false;
                                                            });
                                                         
                                                          }
                                                      
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[4].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[4].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible5 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                    
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible5 = false;
                                                            });
                                                         
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                     
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible5 = false;
                                                            });
                                                        
                                                          }
                                                      
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            );                                      
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisible6,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));             
                                        }else{                  
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[5].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[5].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[5].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible6 = false;
                                                            });
                                                       
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                      
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible6 = false;
                                                            });
                                                          
                                                          }
                                                      
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[5].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[5].opcion == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible6 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                 
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible6 = false;
                                                            });
                                                           
                                                          }else{
                                                           print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                     
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible6 = false;
                                                            });
                                                          }
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[5].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[5].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible6 = false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                    
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible6 = false;
                                                            });
                                                        
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);                                                      
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible6= false;
                                                            });
                                                          }
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            );                                     
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Visibility(
                    visible: _isVisible7,
                    child: Stack(
                      children:[
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: CustomAlertDialog(
                            contentPadding: EdgeInsets.all(5),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan, width: 4),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  height: MediaQuery.of(context).size.height / 2,
                                  //padding: EdgeInsets.all(0),
                                  //color: Colors.white,
                                  child: Center(
                                    child: FutureBuilder(
                                      future: getPreguntas(globals.idRuta),
                                      builder: (BuildContext context, AsyncSnapshot snapshot3) {                       
                                        if(!snapshot3.hasData){   
                                          return Center(child: CircularProgressIndicator(strokeWidth: 2));          
                                        }else{                  
                                          for(int n=0;n<snapshot3.data.length;n++){                                      
                                            return Column(
                                              children: <Widget>[
                                                Container( //Pregunta
                                                  width: 300,
                                                  child: Center(child: Text('${snapshot3.data[6].pregunta}',  style: TextStyle(fontSize: 24),)),
                                                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                               FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[6].respuestas[0].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[6].opcion == 1){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible7= false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);
                                                            setState(() {
                                                               ranking = rankings as List<rankingModelo>;
                                                              _isVisible7 = false;
                                                            });
                                                           
                                                            deleteUbicacion(globals.usuario);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => FinalizarPage(),
                                                            ));
                                                            
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);   
                                                            setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible7 = false;
                                                            });                                                  
                                                            deleteUbicacion(globals.usuario);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => FinalizarPage(),
                                                            ));   
                                                          }                                                    
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[6].respuestas[1].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[6].opcion == 2){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible7= false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);   
                                                             setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible7 = false;
                                                            });                                                   
                                                           
                                                            deleteUbicacion(globals.usuario);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => FinalizarPage(),
                                                            ));
                                                           
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);   
                                                             setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible7 = false;
                                                            });                                                 
                                                            deleteUbicacion(globals.usuario);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => FinalizarPage(),
                                                            ));                                                        
                                                          }
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              FutureBuilder(
                                                  future: getRanking(),
                                                  builder: (BuildContext context, AsyncSnapshot snapshot4) { 
                                                    if(!snapshot4.hasData){    
                                                      return Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                    }else{ 
                                                      for(int i=0; i<snapshot4.data.length;i++){
                                                        if(snapshot4.data[i].nombre == globals.usuario && snapshot4.data[i].rutasId == globals.idRuta){
                                                          globals.idRanking = snapshot4.data[i].id;
                                                        }
                                                      }  
                                                  return Container( //Respuesta3
                                                    width: 250,
                                                    child: RaisedButton(
                                                      color: Colors.cyan,
                                                      child: Text('${snapshot3.data[6].respuestas[2].respuesta}', style: TextStyle(fontSize: 16),),
                                                      padding: EdgeInsets.only(left: 50, right: 50),
                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      onPressed: () {
                                                        setState(() async {
                                                          if(snapshot3.data[6].opcion == 3){
                                                            print("RESPUESTA CORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal + 50;
                                                            globals.aciertos++;
                                                            _isVisible7= false;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);  
                                                              setState(() {
                                                              ranking = rankings as List<rankingModelo>;
                                                              _isVisible7 = false;
                                                            });                                                
                                                            deleteUbicacion(globals.usuario);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => FinalizarPage(),
                                                            ));
                                                          }else{
                                                            print("RESPUESTA INCORRECTA");
                                                            globals.puntuacionTotal = globals.puntuacionTotal - 25;
                                                            globals.fallos++;
                                                            rankingModelo rank = new rankingModelo();
                                                            rank.id = globals.idRanking;
                                                            rank.puntos = globals.puntuacionTotal;
                                                            rank.usuario_id = "1";
                                                            rank.nombre = globals.usuario;
                                                            rank.aciertos = globals.aciertos;
                                                            rank.fallos = globals.fallos;
                                                            rank.tiempo = 0;
                                                            rank.rutasId = globals.idRuta;
                                                            rankingModelo rankings = await actualizarRanking(rank);
                                                             setState(() {
                                                               ranking = rankings as List<rankingModelo>;
                                                              _isVisible7 = false;
                                                            });
                                                            deleteUbicacion(globals.usuario);
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (context) => FinalizarPage(),
                                                            ));
                                                           
                                                          }
                                                       
                                                      },
                                                    );
                                                    })
                                                  );
                                                   }
                                                  }
                                                ),
                                              ],
                                            );                                      
                                          } 
                                        }     
                                      }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  button(_onMapTypeButtonPressed),                
                  BtnSeguirUbicacion(),
                  BtnUbicacion(),
                ],
              ) 
          ]
        ),
      ],
    ),
    FutureBuilder(
      future: getUsuarios(),
      builder: (BuildContext context, AsyncSnapshot snapshot2) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: FutureBuilder(
            future: getRanking(),
            builder: (BuildContext context, AsyncSnapshot snapshot5) {
              if(!snapshot2.hasData || !snapshot5.hasData){
                return Center(child: CircularProgressIndicator(strokeWidth: 2),
                );
              }else{
                List<String> fotos = [];
                List<int> listaRankingPuntos = [];
                List<String> listaRankingNombres = [];
                for(int i=0; i<snapshot5.data.length;i++){
                  if(snapshot5.data[i].nombre == globals.usuario && snapshot5.data[i].rutasId == globals.idRuta){
                    globals.idRanking = snapshot5.data[i].id;
                  }
                }  
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
                          Text('${globals.aciertos}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          Divider(height: 10),
                          Text('${globals.fallos}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}