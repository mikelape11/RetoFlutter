//import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reto/pages/perfil_usuario.dart';
import 'package:reto/theme/theme.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class HomePage extends StatefulWidget {

@override
  Home createState()=> Home();
}

class Home extends State<HomePage>{

  //MAPA 
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }
  static const inicio = LatLng(43.345735526682304, -1.7973972095021267);
  // static const styles = [
  //   'mapbox://styles/srlopezh/ckivkzf483y7i19qkmwg1kgjh',
  //   'mapbox://styles/srlopezh/ckivky8na1xj319o78gpc6pgv',
  //   'mapbox://styles/srlopezh/ckivkxjk91x4e19narx7vhdyu',
  //   'mapbox://styles/srlopezh/ckivkww683xto1ap9ak2aklym',
  //   'mapbox://styles/srlopezh/ckivkw22h3xp21al2rv9xql10',
  //   'mapbox://styles/srlopezh/ckivkusmu3xp91aqly5l49iu0',
  // ];
  // var style = 0;
  // var zdirection = 1;
  // var zvalue = 0.0;
  // var tdirection = 1;
  // var tvalue = 0.0;

  PickedFile _imageFile;

  Icon _setIcon(){
    if(Theme.of(context).primaryColor == Colors.grey[900]) {
      return Icon(Icons.bedtime_outlined);
    } else {
      return Icon(Icons.wb_sunny_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    final List<Widget> children = _widgetOptions();
    return new Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
          ),
          IconButton(
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
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [ 
                Container(
                  //child: _widgetOptions.elementAt(_selectedIndex),
                  child: children[_selectedIndex],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
  List<Widget> _widgetOptions() => [
    Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            messageListArea(),
            submitArea(),
            // Text(
            //   'SOY CHAT', 
            //   style: optionStyle,
            // )
          ],
        )
      ),
    ),
    Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 600,
                child: MapboxMap(
                  styleString: Theme.of(context).primaryColor == Colors.grey[900] ? 'mapbox://styles/mikelape11/ckj1f8lf22py319o3gyfnhd97' : 'mapbox://styles/mikelape11/ckj1fb9fw9kmp19s3qrxrf3t0',
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(target: inicio, zoom: 15,),
                )
              ),
            ]
          ),
         
        ],
      ),
    
    Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: <Widget>[
            Divider(),
            Text(
              'CLASIFICACIÓN',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              margin: EdgeInsets.only(top: 0),
              child: Row(
              children: <Widget>[
                Stack(
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
                    Container( //FOTO TERCERA POSICION
                      margin: EdgeInsets.only(left: 214, top: 110),
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
                    Container( //FOTO PRIMERA POSICION
                      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 84),
                      child:  CircleAvatar(
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
            Container(
              child: Column(
                children: <Widget>[
                  for(int i=4; i<9; i++)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
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
                ],
              ),
            ),
          ],
        )
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget messageListArea() {
    return Container(
      height: 488,
    );
  }

  Widget submitArea() {
    return SizedBox(
      width: 350.0,
      height: 70.0,
      child: Card(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15.0),
      //   side: BorderSide(
      //     color: Colors.grey,
      //     width: 2.0,
      //   ),
      // ),
        child: ListTile(
          contentPadding: EdgeInsets.only(bottom: 5, left: 20),
          title: TextFormField(
            decoration: InputDecoration(
              hintText: "Escribe un mensaje",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan, width: 2.0),
              ),
            ),
            //controller: msgCon,
          ),
          trailing: IconButton(
            icon: Icon(Icons.send),
            color: Colors.cyan,
            disabledColor: Colors.grey,
            onPressed: (){}),
          ),
        ),
    );
  }
}