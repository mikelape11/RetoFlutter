import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:reto/widgets/custom_alert_dialog.dart';

//import 'package:provider/provider.dart';
//import 'package:reto/pages/login.dart';

//import '../theme/theme.dart';

class PortadaPage extends StatefulWidget {
  //PANTALLA DE LA PORTADA
  @override
  _PortadaPageState createState() => _PortadaPageState();
}

class _PortadaPageState extends State<PortadaPage> with WidgetsBindingObserver{
  //USO ESTAS FUNCIONES PARA LA COMPROBACION DELOS PERMISOS DEL GPS, PARA COMPROBAR SI HA HABIDO ALGUN CAMBIO
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if( state == AppLifecycleState.resumed){
      if( await Permission.location.isGranted ){
        Navigator.pushReplacementNamed(context, 'loading');
      }
    }
  }

  String _setImage() { //CAMBIO EL LOGO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo3.png";
      } else {
        return "images/logo4.png";
      } 
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
  
  @override
  Widget build(BuildContext context) {
    //ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    String _setImage() { //CAMBIO EL LOGO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo.png";
      } else {
        return "images/logo2.png";
      } 
    }
    return Scaffold( //EMPIEZA LA PANTALLA DE LA PORTADA
      body: Container( //LE COLOCO EL FONDO DE PANTALLA EN EL BODY
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image:  AssetImage('images/fondo.png'),
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop), 
          )
        ),
        child: Column( //LOGO
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 280, bottom: 50),
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  AssetImage(_setImage())
                  )
                ),
              ),
            ),
            Container( //BOTON EMPEZAR
              margin: EdgeInsets.only(right: 10),
              child: MaterialButton(
                color: Colors.cyan,
                child: Text('EMPEZAR', style: TextStyle(fontSize: 22),),
                padding: EdgeInsets.all(14),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () async{ //PARA COMPROBAR LOS PERMISOS
                  final status = await Permission.location.request();
                  this.accesoGPS(status);
                  //print(status);
                }
              )
            ),
            SizedBox(height: 15),
            Container( //TEXTO
              margin: EdgeInsets.only(top: 20, right: 10),
              child: Text('Es necesario el GPS para usar esta app', style: TextStyle(fontSize: 18,)),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              margin: EdgeInsets.only(top: 0),
              child: IconButton(
                icon: Icon(Icons.contact_support),
                iconSize: 70,
                onPressed: () {
                  informacion(context);
                },
              ),
              
            ),
          ],
        )
      )
    );
  }

  void accesoGPS( PermissionStatus status) { //FUNCION EN LA QUE COMPRUEBA EL ESTADO DE LOS PERMISOS

    switch(status){
      case PermissionStatus.undetermined:
        break;
      case PermissionStatus.granted: //SI ESTA PERMITIDO ENTRA A LA PANTALLA DE LOGIN
        Navigator.pushReplacementNamed(context, 'login');
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings(); //NOS LLEVA A OPCIONES SI NO ESTA PERMITIDO EL ACCESO
    }
  }
}