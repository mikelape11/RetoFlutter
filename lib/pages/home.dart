//import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reto/theme/theme.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reto/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:reto/bloc/mapa/mapa_bloc.dart';

import 'package:reto/widgets/widgets.dart';
import 'package:reto/pages/perfil_usuario.dart';

import '../bloc/mapa/mapa_bloc.dart';
import '../widgets/custom_alert_dialog.dart';
import 'package:dash_chat/dash_chat.dart';

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

  @override
  void dispose() { //LLAMO A LA FUNCION DE CANCELAR SEGUIMIENTO DEL USUARIO DEL MAPA
  // ignore: deprecated_member_use
    context.bloc<MiUbicacionBloc>().cancerlarSeguimiento();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget crearMapa(MiUbicacionState state){ //FUNCION DONDE CREO EL MAPA
    
    if( !state.existeUbicacion ) return Center(child: Text('Ubicando...'));

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
                // messages:[ ChatMessage(
                //   text: "Hello",
                //   user: ChatUser(
                //     containerColor: Colors.cyan,
                //     name: "Fayeed",
                //     uid: "123456789",
                //     avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
                //   ),
                //   createdAt: DateTime.now(),
                //   image: "http://www.sclance.com/images/picture/Picture_753248.jpg",
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
    Center( //PANTALLA DE RANKING
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
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
                      margin: EdgeInsets.only(left: 245, top: 70),
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
                        onTap: () {
                          detalles(context);
                        },
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.blueGrey[300],
                          child: CircleAvatar(
                            radius: 56.0,
                            backgroundImage: _imageFile == null
                              ? AssetImage("images/perfil.png")
                              : FileImage(File(_imageFile.path)),
                          )            
                        ),
                      ),
                    ),
                    Container( //FOTO TERCERA POSICION
                      margin: EdgeInsets.only(left: 214, top: 110),
                      child: GestureDetector(
                        onTap: () {
                          detalles(context);
                        },
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.brown,
                          child: CircleAvatar(
                            radius: 56.0,
                            backgroundImage: _imageFile == null
                              ? AssetImage("images/perfil.png")
                              : FileImage(File(_imageFile.path)),
                          )            
                        ),
                      ),
                    ),
                    Container( //FOTO PRIMERA POSICION
                      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 84),
                      child:  GestureDetector(
                        onTap: () {
                          detalles(context);
                        },
                         child: CircleAvatar(
                          radius: 83,
                          backgroundColor: Colors.amberAccent[400],
                          child: CircleAvatar(
                            radius:  79,
                            backgroundImage: _imageFile == null
                              ? AssetImage("images/perfil.png")
                              : FileImage(File(_imageFile.path)),
                          )            
                        ),
                      ),
                    ),
                    Container( //NOMBRE SEGUNDA POSICION
                      width: 110,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 240, left: 5),
                      child: Text(
                        'Nombre',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[300]),
                      ),
                    ),
                    Container( //PUNTUACION SEGUNDA POSICION
                      width: 110,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 260, left: 5),
                      child: Text(
                        '2100',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container( //FOTO PRIMERA POSICION
                      width: 120,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 215, left: 108),
                      child: Text(
                        'Nombre',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amberAccent[400]),
                      ),
                    ),
                    Container( //PUNTUACION PRIMERA POSICION
                      width: 120,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 235, left: 108),
                      child: Text(
                        '2200',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container( //FOTO TERCERA POSICION
                      width: 110,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 240, left: 220),
                      child: Text(
                        'Nombre',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                    ),
                    Container( //PUNTUACION TERCERA POSICION
                      width: 110,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 260, left: 220),
                      child: Text(
                        '2000',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ), 
              ])
            ),
            Divider(),
            Container( //CONTENEDOR PARA LOS OTROS PUESTOS
              child: Column(
                children: <Widget>[
                  for(int i=4; i<21; i++) //HACE FALTA HACER UN FOR PARA TODOS LOS JUGADORES
                  GestureDetector(
                    onTap: () {
                      detalles(context);
                    },
                    child: Container( //CONTAINER PARA LOS DATOS DEL JUGADOR
                      margin: EdgeInsets.only(top: 10),
                      child: Row( //CREO UNA FILA PARA MOSTRARLOS
                        children: <Widget>[
                          Container( //NUMERO POSICION
                            width: 40,
                            height: 40,
                            color: Colors.cyan,
                            alignment: Alignment.center,
                            child: Text(
                              '${i}', 
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
                                backgroundImage: _imageFile == null
                                  ? AssetImage("images/perfil.png")
                                  : FileImage(File(_imageFile.path)),
                              )            
                            ),
                          ),
                          Container( //NOMBRE DEL USUARIO
                            margin: EdgeInsets.only(left: 13),
                            width: 132,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              'Nombre Usuario', 
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
                              '1900', 
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
        )
      ),
    )
  ];

  void _onItemTapped(int index) { //FUNCION PARA SELECCIONAR LA PANTALLA DE LOS 3 DIFERENTES QUE EXISTEN
    setState(() {
      _selectedIndex = index;
    });
  }

  // Widget messageListArea() { //EL WIDGET PARA VER LOS MENSAJES DE TEXTO
  //   return Container(
  //     height: 488,
  //   );
  // }

  // Widget submitArea() { //EL WIDGET PARA ENVIAR LOS MENSAJES
  //   return SizedBox(
  //     width: 350.0,
  //     height: 70.0,
  //     child: Card(
  //     // shape: RoundedRectangleBorder(
  //     //   borderRadius: BorderRadius.circular(15.0),
  //     //   side: BorderSide(
  //     //     color: Colors.grey,
  //     //     width: 2.0,
  //     //   ),
  //     // ),
  //       child: ListTile(
  //         contentPadding: EdgeInsets.only(bottom: 5, left: 20),
  //         title: TextFormField(
  //           decoration: InputDecoration(
  //             hintText: "Escribe un mensaje",
  //             focusedBorder: UnderlineInputBorder(
  //               borderSide: BorderSide(color: Colors.cyan, width: 2.0),
  //             ),
  //           ),
  //           //controller: msgCon,
  //         ),
  //         trailing: IconButton(
  //           icon: Icon(Icons.send),
  //           color: Colors.cyan,
  //           disabledColor: Colors.grey,
  //           onPressed: (){}),
  //         ),
  //       ),
  //   );
  // }

  void detalles(BuildContext context) {
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
            height: MediaQuery.of(context).size.height / 2.75,
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
                        Column(
                          children: <Widget>[
                            Text('Belako', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Divider(height: 10),
                            Text('2100', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Divider(height: 10),
                            Text('2H 30Min', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Divider(height: 10),
                            Text('7', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            Divider(height: 10),
                            Text('1', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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