import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reto/pages/home.dart';

import '../theme/theme.dart';

class MenuRuta extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    Icon _setIcon(){
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return Icon(Icons.bedtime_outlined);
      } else {
        return Icon(Icons.wb_sunny_outlined);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("MENU"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: <Widget>[
                Divider(),
                Text(
                  'ESCOGE TU RUTA',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(0.0),
                      child: FlatButton(
                        padding: EdgeInsets.zero,
	                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: FittedBox(
                                child: Image.asset('images/Rutas/ruta1.jpg'),
                                fit: BoxFit.fill,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              height: 280,
                              width: MediaQuery.of(context).size.width/2.5,                         
                            ),
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  height: 287,
                                  width: MediaQuery.of(context).size.width/2.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Colors.cyan),
                                      left: BorderSide(width: 1.0, color: Colors.cyan),
                                      right: BorderSide(width: 1.0, color: Colors.cyan),
                                      bottom: BorderSide(width: 1.0, color: Colors.cyan),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'IRÚN',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ), 
                          ],
                        ),
                      )
                      
                    ),
                    Container(
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: FittedBox(
                                child: Image.asset('images/Rutas/ruta2.jpg'),
                                fit: BoxFit.fill,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              height: 280,
                              width: MediaQuery.of(context).size.width/2.5,                         
                            ),
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  height: 287,
                                  width: MediaQuery.of(context).size.width/2.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Colors.cyan),
                                      left: BorderSide(width: 1.0, color: Colors.cyan),
                                      right: BorderSide(width: 1.0, color: Colors.cyan),
                                      bottom: BorderSide(width: 1.0, color: Colors.cyan),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'IRÚN - HENDAIA',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ), 
                          ],
                        ),
                      )
                      
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: FittedBox(
                                child: Image.asset('images/Rutas/ruta3.jpg'),
                                fit: BoxFit.fill,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              height: 280,
                              width: MediaQuery.of(context).size.width/2.5,                         
                            ),
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  height: 287,
                                  width: MediaQuery.of(context).size.width/2.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Colors.cyan),
                                      left: BorderSide(width: 1.0, color: Colors.cyan),
                                      right: BorderSide(width: 1.0, color: Colors.cyan),
                                      bottom: BorderSide(width: 1.0, color: Colors.cyan),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'DONOSTI 1',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ), 
                          ],
                        ),
                      )
                    ),
                    Container(
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: FittedBox(
                                child: Image.asset('images/Rutas/ruta4.jpg'),
                                fit: BoxFit.fill,
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              height: 280,
                              width: MediaQuery.of(context).size.width/2.5,                         
                            ),
                            ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  height: 287,
                                  width: MediaQuery.of(context).size.width/2.4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Colors.cyan),
                                      left: BorderSide(width: 1.0, color: Colors.cyan),
                                      right: BorderSide(width: 1.0, color: Colors.cyan),
                                      bottom: BorderSide(width: 1.0, color: Colors.cyan),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'DONOSTI 2',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ), 
                          ],
                        ),
                      )
                    ),
                  ],
                ),
                Divider(),
                Text(
                  'COMING SOON',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Divider(),
              ],
            )
          ),
        )
      )
    );
  }
}