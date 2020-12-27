import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geolocator/geolocator.dart' as Geolocator;

import 'package:permission_handler/permission_handler.dart';
import 'package:reto/helpers/helpers.dart';
import 'package:reto/pages/portada.dart';
import 'package:reto/pages/login.dart';

class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver{

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
      if( await GeolocatorPlatform.instance.isLocationServiceEnabled()){
        Navigator.pushReplacement(context, navegarMapaFadeIn(context, LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){
            return Center(child: Text(snapshot.data));
          }else{
            return Center( child: CircularProgressIndicator(strokeWidth: 2));
          }
          // return Center(
          //  
          // );
        },
      ),
    );
  }

  Future checkGpsYLocation(BuildContext context) async{

    // PermisoGPS
    final permisoGPS = await Permission.location.isGranted;
    
    // GPS esta activo
    
    final gpsActivo = await GeolocatorPlatform.instance.isLocationServiceEnabled();
    
    if( permisoGPS && gpsActivo ){
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, LoginPage()));
      return '';
    }else if(!permisoGPS){
      Navigator.pushReplacement(context, navegarMapaFadeIn(context, PortadaPage()));
      return 'Es necesario el permiso del GPS';
    }else if(!gpsActivo){
      return 'Active el GPS';
    }
  }
}