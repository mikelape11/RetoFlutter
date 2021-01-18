import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:reto/widgets/sliding_cards.dart';

import '../theme/theme.dart';


class MenuRuta extends StatelessWidget {
  
  //PANTALLA DE ELEGIR LA RUTA
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return Icon(Icons.bedtime_outlined);
      } else {
        return Icon(Icons.wb_sunny_outlined);
      }
    }


    return Scaffold( //EMPIEZA LA PANTALLA DEL MENU
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("MENU"),
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              children: <Widget>[
                Divider(),
                Text( //TITULO
                  'ESCOGE TU RUTA',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Divider(),
                SlidingCardsView(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('DESLIZA PARA MÁS ', style: TextStyle(fontSize: 25)),
                    Icon(
                      Icons.double_arrow,
                      size: 35,
                    ),
                  ],
                ),
                
              ],
            )
          ),
        )
      )
    );
  }
}