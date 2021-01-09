import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart' as Geo;
import 'package:permission_handler/permission_handler.dart';
import 'package:reto/widgets/custom_alert_dialog.dart';

import 'package:reto/helpers/helpers.dart';
import 'package:reto/pages/portada.dart';
import 'package:reto/pages/login.dart';

class LoadingPage extends StatefulWidget {
  //PANTALLA DE LOADING
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver{
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
      if( await Geo.GeolocatorPlatform.instance.isLocationServiceEnabled()){
        Navigator.pushReplacement(context, navegarMapaFadeIn(context, LoginPage()));
      }
    }
  }

  void mensajeAlerta(BuildContext context) {
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
          height: MediaQuery.of(context).size.height / 8,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container( //Respuesta1
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Text(
                    'Active el GPS',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.cyan),
                  ),
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
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            return Center(child: Text(snapshot.data)); //DATOS
          }else{
            return Center( child: CircularProgressIndicator(strokeWidth: 2)); //CIRCULO DE CARGA
          }
        },
      ),
    );
  }

  Future checkGpsYLocation(BuildContext context) async{ //EN ESTA FUNCION SE COMPRUEBA SI ESTA ACTIVADO EL GPS Y LOS PERMISOS

    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    
    // GPS esta activo
    final gpsActivo = await Geo.GeolocatorPlatform.instance.isLocationServiceEnabled();
    
    if( permisoGPS && gpsActivo ){
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, LoginPage()));
      return '';
    }else if(!permisoGPS){
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, PortadaPage()));
      return 'Es necesario el permiso del GPS';
    }else if(!gpsActivo){
      return mensajeAlerta(context);
    }
  }
}