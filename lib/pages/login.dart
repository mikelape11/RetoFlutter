import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:reto/pages/menu_ruta.dart';
import 'package:reto/pages/registro.dart';
//import 'package:reto/pages/home.dart';

import 'package:reto/theme/theme.dart';

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
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('LOGIN', style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.only(left: 150, right: 150),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MenuRuta(),
                    ));
                  },
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
      )
    );
  }
}