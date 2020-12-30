import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:reto/pages/home.dart';
import 'package:reto/pages/login.dart';

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

    return Scaffold( //EMPIEZA LA PANTALLA DEL REGISTRO
      appBar: AppBar(
        title: Text("PERFIL"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
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
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('GUARDAR', style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.only(left: 136, right: 136),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                )
              ),
              Container( //BOTON DE CERRAR SESION
                margin: EdgeInsets.only(top: 25),
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('CERRAR SESIÓN', style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.only(left: 115, right: 115),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
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