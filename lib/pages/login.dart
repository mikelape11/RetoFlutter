import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:reto/pages/menu_ruta.dart';
import 'package:reto/pages/registro.dart';

import 'package:reto/theme/theme.dart';
import 'package:reto/theme/colors.dart';

import '../models/usuarioModelo.dart';

import 'package:http/http.dart' as http;

import 'package:reto/globals/globals.dart' as globals;
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  //PANTALLA DE LOGIN
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA
    
    String _setImage() { //CAMBIO EL LOGO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo.png";
      } else {
        return "images/logo2.png";
      } 
    }

    Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return Icon(Icons.bedtime_outlined);
      } else {
        return Icon(Icons.wb_sunny_outlined);
      }
    }

    TextEditingController firstController = TextEditingController();
    TextEditingController secondController = TextEditingController();
    String _usuario;
    String _password;
    List<GlobalKey<FormState>> _formKeysList= [
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
    ];

    String validarUsuario(String value) {
      if (value.isEmpty) {
        return "Rellena el campo";
      } else if (value.length < 3) {
        return "Tiene que tener como minimo 5 caracteres";
      } else if (value.length > 10) {
        return "Tiene que tener como maximo 10 caracteres";
      } else if(value == _usuario){
        return "El usuario no existe";
      } else 
        return null;
    }

    String validarPassword(String value) {
      if (value.isEmpty) {
        return "Rellena el campo";
      } else if (value.length < 8) {
        return "Tiene que tener como minimo 8 caracteres";
      } else if (value.length > 12) {
        return "Tiene que tener como maximo 12 caracteres";
      } else if(value == _password){
        print(value);
        print(_password);
        return "La contraseña no es correcta";
      } else 
        return null;
    }

    Future<List<usuarioModelo>> getUsuarios() async {
      var data = await http.get('${globals.ipLocal}/usuarios/todos');
      var jsonData = json.decode(data.body);
      
      List<usuarioModelo> usuario = [];
      for (var e in jsonData) {
        usuarioModelo usuarios = new usuarioModelo();
        usuarios.usuario = e["usuario"];
        usuarios.password = e["password"];
        usuarios.avatar = e["avatar"];
        usuario.add(usuarios);
      }
      return usuario;
    }

    return Scaffold( //EMPIEZA LA PANTALLA DE LOGIN
      appBar: AppBar(
        title: Text("LOGIN"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true,
          child: CustomPaint(
            painter: CurvePainter(context),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container( //LOGO
                    margin: EdgeInsets.only(top: 60),
                    height: 145,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        //  image:  AssetImage('images/logo.png')
                        image:  AssetImage(_setImage())
                      )
                    ),
                  ),
                  Container( //PRIMER CAMPO: USUARIO
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Form(
                      autovalidate: true,
                      key: _formKeysList[0],
                      child: TextFormField(
                        controller: firstController,
                        validator: validarUsuario,
                        onSaved: (String value){
                          _usuario = value;
                        },
                        decoration: InputDecoration(
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
                  ),
                  Container( //SEGUNDO CAMPO: CONTRASEÑA
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Form(
                      autovalidate: true,
                      key: _formKeysList[1],
                      child: TextFormField(
                        obscureText: true,
                        controller: secondController,
                        validator: validarPassword,
                         onSaved: (String value){
                          _password = value;
                        },
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
                  ),
                  Container( //BOTON LOGIN
                    margin: EdgeInsets.only(top: 25),
                    child: FutureBuilder(
                      future: getUsuarios(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return RaisedButton(
                        color: Colors.cyan,
                        child: Text('LOGIN', style: TextStyle(fontSize: 16),),
                        padding: EdgeInsets.only(left: 150, right: 150),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () async{
                          String usuario = firstController.text;
                          String password = secondController.text;
                          int cont = 0;
                          for(int i=0; i<snapshot.data.length; i++){
                            if (_formKeysList[1].currentState.validate()) { 
                            }
                            if(snapshot.data[i].usuario == usuario && snapshot.data[i].password == password){
                                globals.usuario = usuario;
                                globals.password = password;
                                globals.avatar = snapshot.data[i].avatar;
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MenuRuta(),
                                ));  
                            }else{
                              if(snapshot.data[i].usuario != usuario){
                                 cont ++; 
                              }
                              if(cont == snapshot.data.length){
                                  if (_formKeysList[0].currentState.validate()) { 
                                      _formKeysList[0].currentState.save();
                                    }
                              }
                              if(snapshot.data[i].password != password && snapshot.data[i].usuario == usuario){
                                if (_formKeysList[1].currentState.validate()) { 
                                  _formKeysList[1].currentState.save();
                                } 
                              }  
                            }       
                          }  
                        },                     
                      );
                      }
                    )
                  ),
                  Column( //FILA DE BOTONES
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container( //BOTON DE GOOGLE
                        margin: EdgeInsets.only(top: 20),
                        child: SignInButtonBuilder(
                            text: 'Sign in with Email',
                            icon: Icons.email,
                            onPressed: () {},
                            backgroundColor: Colors.red,
                          )
                      ),
                      Container( //BOTON DE GOOGLE
                        margin: EdgeInsets.only(top: 2),
                        child: SignInButton(
                          Buttons.GitHub,
                          onPressed: () {
                          },
                        ),
                      ),
                      Container( //BOTON DE GOOGLE
                        margin: EdgeInsets.only(top: 2),
                        child: SignInButton(
                          Buttons.Twitter,
                          onPressed: () {
                          },
                        ),
                      ),
                    ],
                  ),
                  Container( //TEXTO PARA CREAR UNA NUEVA CUENTA
                    margin: EdgeInsets.only(top: 15),
                    child: InkWell(
                      child: Text('¿Todavía no tienes cuenta?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistroPage(),
                        ));
                      },
                    )
                  ),
                  Container( //BOTON REGISTRO
                    margin: EdgeInsets.only(top: 15),
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text('REGISTRATE', style: TextStyle(fontSize: 16),),
                      padding: EdgeInsets.only(left: 120, right: 120),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: () async{
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistroPage(),
                        ));                     
                      }
                    )
                  ),
                ],
              )
            )
          ),
        )
      )
    );
  }
}

class CurvePainter extends CustomPainter{

  final BuildContext context ;
  CurvePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path = Path();
    path.lineTo(0, size.height*0.78);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.71);
    path.quadraticBezierTo(size.width*0.34, size.height*0.90, size.width*0.41, size.height*0.76);
    path.quadraticBezierTo(size.width*0.51, size.height*0.51, size.width*0.64, size.height*0.70);
    path.quadraticBezierTo(size.width*0.74, size.height*0.86, size.width, size.height*0.62);
    path.lineTo(size.width, 0);
    path.close();

    if(Theme.of(context).primaryColor == Colors.grey[900]) {
       paint.color = colorOne;
     }else{
       paint.color = colorTwo;
     }
    canvas.drawPath(path, paint);

    path =Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
    path.quadraticBezierTo(size.width*0.35, size.height*0.88, size.width*0.40, size.height*0.75);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.70);
    path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    if(Theme.of(context).primaryColor == Colors.grey[900]) {
       paint.color = colorThree;
     }else{
       paint.color = colorFour;
     }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

