import 'package:flutter/material.dart';
import 'package:reto/pages/home.dart';


class RegistroPage extends StatelessWidget {

 @override
 Widget build(BuildContext context) {
   return new Scaffold(
       appBar: AppBar(
         title: Text("Registro"),
       ),
       body: Center(
        child: RaisedButton(
          color: Colors.cyan,
            child: Text('EMPEZAR', style: TextStyle(fontSize: 22),),
            padding: EdgeInsets.all(14),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
        )
      )
    );
  }
}