import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:provider/provider.dart';
//import 'package:reto/pages/login.dart';

//import '../theme/theme.dart';

class PortadaPage extends StatefulWidget {

  @override
  _PortadaPageState createState() => _PortadaPageState();
}

class _PortadaPageState extends State<PortadaPage> with WidgetsBindingObserver{
  
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
  
  @override
  Widget build(BuildContext context) {
    //ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    String _setImage() {
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo.png";
      } else {
        return "images/logo2.png";
      } 
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image:  AssetImage('images/fondo11.png'),
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop), 
          )
        ),
        child: Column(
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
            Container(
              margin: EdgeInsets.only(right: 10),
              child: MaterialButton(
                color: Colors.cyan,
                child: Text('EMPEZAR', style: TextStyle(fontSize: 22),),
                padding: EdgeInsets.all(14),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () async{
                  final status = await Permission.location.request();
                  this.accesoGPS(status);
                  //print(status);
                }
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 20, right: 10),
              child: Text('Es necesario el GPS para usar esta app'),
            ),
          ],
        )
      )
    );
  }

  void accesoGPS( PermissionStatus status) {

    switch(status){

      case PermissionStatus.undetermined:
        break;
      case PermissionStatus.granted:
        Navigator.pushReplacementNamed(context, 'login');
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        
      
    }
  }
}