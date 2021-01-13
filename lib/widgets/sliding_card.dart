import 'package:flutter/material.dart';
import 'package:reto/pages/home.dart';

class SlidingCard extends StatelessWidget {
  final String name; //<-- title of the event
  final String date; //<-- date of the event
  final String assetName; //<-- name of the image to be displayed

  const SlidingCard({
    Key key,
    @required this.name,
    @required this.date,
    @required this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), //<--custom shape
      child: Column(
        children: <Widget>[
          ClipRRect(  //<--clipping image
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)), 
            child: Image.asset( //<-- main image
              'images/Rutas/$assetName',
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _CardContent( //<--replace the Container with CardContent
              name: name,
              date: date,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final String name;
  final String date;

  const _CardContent({Key key, @required this.name, @required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              child: Text(name, style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold))
            ),
          ),
          SizedBox(height: 18),
          Center(
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    //Text(date, style: TextStyle(color: Colors.grey)),
                      Text("DISTANCIA: ", style: TextStyle(color: Colors.grey, fontSize: 22)),
                      SizedBox(width: 10),
                      Text("2.5 KM", style: TextStyle(color: Colors.grey, fontSize: 22)),
                    ],
                  ), 
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("DURACIÓN: ", style: TextStyle(color: Colors.grey, fontSize: 22)),
                      SizedBox(width: 10),
                      Text("2H 30MIN", style: TextStyle(color: Colors.grey, fontSize: 22)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                padding: EdgeInsets.all(10),
                color: Colors.cyan,
                child: Text('Vamo a Jugar', style: TextStyle(fontSize: 25),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}