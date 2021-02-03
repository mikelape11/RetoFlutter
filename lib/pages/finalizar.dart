
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reto/theme/theme.dart';
import 'package:confetti/confetti.dart';

import 'ranking.dart';

class FinalizarPage extends StatefulWidget {
  //PANTALLA DE REGISTRO
  @override
    Finalizar createState()=> Finalizar();
  }

class Finalizar extends State<FinalizarPage>{
  ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 3));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA

    Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return Icon(Icons.bedtime_outlined);
      } else {
        return Icon(Icons.wb_sunny_outlined);
      }
    }

    return Scaffold( //EMPIEZA LA PANTALLA DEL REGISTRO
      appBar: AppBar(
        title: Text("FIN"),
        automaticallyImplyLeading: false,
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
              Container(
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        //CENTER 
                        Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                            confettiController: _controllerCenter,
                            emissionFrequency: 0.03, 
                            numberOfParticles: 20,
                            blastDirectionality: BlastDirectionality
                                .explosive, 
                            shouldLoop:
                                true, 
                            colors: [
                              Colors.green,
                              Colors.yellow,
                              Colors.blue,
                              Colors.pink,
                              Colors.orange,
                              Colors.purple,
                              Colors.red
                            ], 
                          ),
                        ),
                      ]
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    Center(
                      child: Container(
                        child: Text('¡GRACIAS POR JUGAR A', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),),
                      ),
                    ), 
                    SizedBox(
                      height: 10,
                    ),       
                    Center(
                      child: Container(
                        child: Text('ROUTE QUEST!', style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.cyan),),
                      ),
                    ),     
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Positioned(
                                left: -120,
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.19,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:  AssetImage('images/mel.png'),
                                    )
                                  ),
                                ),
                              ),                            
                              Positioned(
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.23,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:  AssetImage('images/javi.png'),
                                    )
                                  ),
                                ),
                              ),                            
                              Positioned(
                                left: 120,
                                child: Container(
                                  height: MediaQuery.of(context).size.height*0.23,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:  AssetImage('images/mik.png'),
                                    )
                                  ),
                                ),
                              ),         
                            ],                                
                          ),                        
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(10),
                      color: Colors.cyan,
                      child: Text('VER RANKING', style: TextStyle(fontSize: 25),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      onPressed: () async{
                        Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => rankingPage(),
                                ));
                        
                      },
                    ),
                  ],
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}

