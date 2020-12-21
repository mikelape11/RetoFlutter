import 'package:flutter/material.dart';
import 'package:reto/pages/login.dart';

class PortadaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image:  AssetImage('images/fondo11.png'),
            colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop), 
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
                    image:  AssetImage('images/logo.png')
                  )
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: RaisedButton(
                color: Colors.cyan,
                child: Text('EMPEZAR', style: TextStyle(fontSize: 22),),
                padding: EdgeInsets.all(14),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
                },
              )
            )
          ],
        )
      )
    );
  }
}