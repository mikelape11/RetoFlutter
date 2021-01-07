import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:reto/pages/home.dart';
import 'package:reto/pages/login.dart';
import 'package:reto/widgets/custom_alert_dialog.dart';

import '../theme/theme.dart';

class PerfilUsuario extends StatefulWidget {
  //PANTALLA DE PERFIL DE USUARIO
  @override
  PerfilUsuarioPage createState()=> PerfilUsuarioPage();

}

class PerfilUsuarioPage extends State<PerfilUsuario>{

  @override
  Widget build(BuildContext context) {

    PickedFile _imageFile; //PARA LA FOTO DE PERFIL
    final ImagePicker _picker = ImagePicker(); //PARA LA FOTO DE PERFIL
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA

    String _setImage() { //CAMBIO EL LOGO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo3.png";
      } else {
        return "images/logo4.png";
      } 
    }

    Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return Icon(Icons.bedtime_outlined);
      } else {
        return Icon(Icons.wb_sunny_outlined);
      }
    }

    void takePhoto(ImageSource source) async{ //FUNCION PARA LA FOTO DE PERFIL
      final pickedFile = await _picker.getImage(
        source: source,
      );
      setState((){
        _imageFile = pickedFile;
      });
    }

    Widget bottomSheet() { //FUNCION PARA LAS OPCIONES DE LA FOTO DE PERFIL
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Escoge tu Avatar",
              style: TextStyle(
                fontSize: 20.0
              ), 
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera_outlined),
                  onPressed: (){
                    takePhoto(ImageSource.camera);
                  },
                  label: Text("Camara")
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image_outlined),
                  onPressed: (){
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text("Galeria")
                )
              ],
            )
          ]
        ),
      );
    }

    Widget imageProfile(){ //EL WIDGET DONDE SE COLOCARA LA FOTO DE PERFIL
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: 25),
          child: Stack(
            children: <Widget>[
               CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.cyan,
                child: CircleAvatar(
                  radius: 77.0,
                   backgroundImage: _imageFile == null
                    ? AssetImage("images/perfil.png")
                    : FileImage(File(_imageFile.path)),
                )            
              ),
              Positioned(
                bottom: 25.0,
                right: 25.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      builder: ((builder) => bottomSheet()),
                    );
                  },
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.cyan,
                    size: 28.0,
                  ),
                )
              )
            ],
          )
        ),
      );
    }

    void informacion(BuildContext context) {
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
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 1.22,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 200,
                    width: 200,//Pregunta
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:  AssetImage(_setImage())
                      )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container( //Respuesta1
                    padding: EdgeInsets.symmetric(horizontal: 45.0),
                    child: Text(
                      'BIENVENIDO A ROUTE QUEST',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.cyan),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container( 
                    padding: EdgeInsets.symmetric(horizontal: 23.0),//Respuesta2
                    child: Text(
                      'Route Quest trata sobre un juego de preguntas sobre localizaciones especificas de nuestras rutas personalizadas para aquellos que desean conocer o visitar ciertos lugares del mundo. \n\nAparte de conocer lugares nuevos, podrás competir contra otros usuarios e incluso chatear con ellos.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container( //Respuesta
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    void pregunta(BuildContext context) {
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
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 2,
            //padding: EdgeInsets.all(0),
            //color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container( //Pregunta
                    width: 300,
                    child: Center(child: Text('¿En qué año se abrió la biblioteca Carlos Blanco Aguinaga?',  style: TextStyle(fontSize: 24),)),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container( //Respuesta1
                    width: 300,
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text('RESPUESTA BAT', style: TextStyle(fontSize: 16),),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                      },
                    )
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container( //Respuesta2
                    width: 300,
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text('RESPUESTA BI', style: TextStyle(fontSize: 16),),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                      },
                    )
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container( //Respuesta3
                    width: 300,
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text('RESPUESTA HIRU', style: TextStyle(fontSize: 16),),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ));
                      },
                    )
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }

    return Scaffold( //EMPIEZA LA PANTALLA DEL REGISTRO
      appBar: AppBar(
        title: Text("PERFIL"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
          ),
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: Icon(Icons.check, size: 26,),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container( //PRIMER CAMPO: USUARIO
                margin: EdgeInsets.only(top: 35),
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  decoration: InputDecoration(
                    // enabledBorder: UnderlineInputBorder(      
                    //   borderSide: BorderSide(color: Colors.cyan),   
                    // ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                    ),  
                    contentPadding: EdgeInsets.only(top: 22), // add padding to adjust text
                    hintText: "Usuario",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                      child: Icon(Icons.account_circle_outlined, size: 20.0, color: Colors.cyan,),
                    ),
                  ),
                ),
              ),
              Container( //SEGUNDO CAMPO: CONTRASEÑA
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                    ), 
                    contentPadding: EdgeInsets.only(top: 22), // add padding to adjust text
                    hintText: "Password",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                      child: Icon(Icons.lock_outline, size: 20.0, color: Colors.cyan,),
                    ),
                  ),
                ),
              ),
              imageProfile(), //FOTO DE PERFIL
              Container( //BOTON DE GUARDAR 
                margin: EdgeInsets.only(top: 25),
                width: 350,
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('GUARDAR', style: TextStyle(fontSize: 16),),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                )
              ),
              Container( //BOTON DE GUARDAR 
                margin: EdgeInsets.only(top: 25),
                width: 350,
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('INFORMACIÓN', style: TextStyle(fontSize: 16),),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){           
                    informacion(context);
                  },
                )
              ),
              Container( //BOTON DE CERRAR SESION
                margin: EdgeInsets.only(top: 25),
                width: 350,
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('CERRAR SESIÓN', style: TextStyle(fontSize: 16),),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
                  },
                )
              ),
              Container( //BOTON DE CERRAR SESION
                margin: EdgeInsets.only(top: 25),
                width: 350,
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('POPUP', style: TextStyle(fontSize: 16),),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    pregunta(context);
                  },
                )
              ),
            ],
          )
        )
      )
    );
  }
}