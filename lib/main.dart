import 'package:flutter/material.dart';
import 'package:reto/pages/portada.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
 // This widget is the root of your application.
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'NavigationDrawer Demo',
     theme: ThemeData.dark(),
     home: PortadaPage(),
     debugShowCheckedModeBanner: false,
   );
 }
}