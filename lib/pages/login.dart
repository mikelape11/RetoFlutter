import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:reto/pages/menu_ruta.dart';
import 'package:reto/pages/registro.dart';
//import 'package:reto/pages/home.dart';

import 'package:reto/theme/theme.dart';
import 'package:reto/theme/colors.dart';

import '../models/usuarioModelo.dart';

import 'package:http/http.dart' as http;

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
  final _formKey = GlobalKey<FormState>();

  Future<List<usuarioModelo>> getUsuarios() async {
    var data = await http.get('http://10.0.2.2:8080/usuarios/todos');
    var jsonData = json.decode(data.body);

    List<usuarioModelo> usuario = [];
    for (var e in jsonData) {
      usuarioModelo usuarios = new usuarioModelo();
      usuarios.usuario = e["usuario"];
      usuarios.password = e["password"];
      usuario.add(usuarios);
    }
    return usuario;
  }

    return Scaffold( //EMPIEZA LA PANTALLA DE LOGIN
      appBar: AppBar(
        title: Text("LOGIN"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: CustomPaint(
            painter: CurvePainter(context),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container( //LOGO
                    margin: EdgeInsets.only(top: 90),
                    height: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        //  image:  AssetImage('images/logo.png')
                        image:  AssetImage(_setImage())
                      )
                    ),
                  ),
                  Container( //PRIMER CAMPO: USUARIO
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      controller: firstController,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'rellena el campo';
                        }else if(value == "no existe"){
                          firstController.text = "";
                          return 'el usuario no existe';
                        }
                      },
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
                      obscureText: true,
                      controller: secondController,
                      validator: (String value){
                        if(value.isEmpty){
                          return 'rellena el campo';
                        }else if(value == "no coincide"){
                          secondController.text = "";
                          return 'contraseña incorrecta';
                        }
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
                  Container( //TEXTO OLVIDAR CONTRASEÑA
                    margin: EdgeInsets.only(left: 200, top: 3),
                    child: Text('Forgot Password?',style: TextStyle( fontWeight: FontWeight.bold),)
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
                          for(int i=0; i<snapshot.data.length; i++){
                              //print(snapshot.data[i].usuario);
                                if (_formKey.currentState.validate()) {
                                    Scaffold.of(context);
                                  }
                              if(snapshot.data[i].usuario == usuario && snapshot.data[i].password == password){
                                print("Existe"); 
                                  Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MenuRuta(),
                                ));                              
                              }else{
                            
                                if(snapshot.data[i].usuario != usuario){
                                  firstController.text = "no existe";
                                    if (_formKey.currentState.validate()) {
                                    Scaffold.of(context);
                                  }
                                }else if(snapshot.data[i].usuario == usuario && snapshot.data[i].password != password){
                                  secondController.text = "no coincide";
                                }   
                              }       
                          }  
                        },
                      
                      );
                      }
                    )
                  ),
                  Container( //TEXTO LOGEAR CON
                    margin: EdgeInsets.only(top: 20),
                    child: Text('Login with', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ),
                  Row( //FILA DE BOTONES
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container( //BOTON DE GOOGLE
                        margin: EdgeInsets.only(top: 25, right: 10),
                        child: RaisedButton(
                          color: Colors.red,
                          child: Text('GOOGLE', style: TextStyle(fontSize: 16),),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegistroPage(),
                            ));
                          },
                        )
                      ),
                      Container( //BOTON DE TWITTER
                        margin: EdgeInsets.only(top: 25,  left: 10, right: 10),
                        child: RaisedButton(
                          color: Colors.cyan,
                          child: Text('TWITTER', style: TextStyle(fontSize: 16),),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegistroPage(),
                            ));
                          },
                        )
                      ),
                      Container( //BOTON DE FACEBOOK
                        margin: EdgeInsets.only(top: 25,  left: 10),
                        child: RaisedButton(
                          color: Colors.blue[800],
                          child: Text('FACEBOOK', style: TextStyle(fontSize: 16),),
                          padding: EdgeInsets.only(left: 15, right: 15),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegistroPage(),
                            ));
                          },
                        )
                      ),
                    ],
                  ),
                  Container( //TEXTO PARA CREAR UNA NUEVA CUENTA
                    margin: EdgeInsets.only(top: 30),
                    child: InkWell(
                      child: Text('You dont have an account? SIGN UP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistroPage(),
                        ));
                      },
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
    path.quadraticBezierTo(size.width*0.51, size.height*0.51, size.width*0.65, size.height*0.70);
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

// class _HeaderPaintDiagonal extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//     ..color = Colors.cyan
//     ..style = PaintingStyle.stroke //una vez dibujado cambiar por .fill
//     ..strokeWidth = 15;
//     final path = Path();
//     path.lineTo(size.width, size.width*0.20);
//     canvas.drawPath(path, paint);
//     final path2 = Path();
//     path2.moveTo(-10,20);
//     path2.lineTo(size.width, size.width*0.26);
//     canvas.drawPath(path2, paint);
//     final path3 = Path();
//     path3.moveTo(-10,580);
//     path3.lineTo(size.width, size.width*1.66);
//     canvas.drawPath(path3, paint);
//     final path4 = Path();
//     path4.moveTo(-10,600);
//     path4.lineTo(size.width, size.width*1.72);
//     canvas.drawPath(path4, paint);
//   }
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
 }

