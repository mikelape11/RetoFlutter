import 'package:flutter/material.dart';
import 'package:reto/pages/loading_page.dart';
import 'package:reto/pages/login.dart';
import 'package:reto/pages/portada.dart';
import 'package:provider/provider.dart';

import './theme/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      home: PortadaPage(),
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
      routes: {
        'login'   : ( _ ) => LoginPage(),
        'loading' : ( _ ) => LoadingPage(),
        'portada' : ( _ ) => PortadaPage(),
      },
    );
  }
}
