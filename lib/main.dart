import 'package:flutter/material.dart';
import 'package:reto/models/datosGlobalesModelo.dart';
import 'package:reto/pages/loading_page.dart';
import 'package:reto/pages/login.dart';
import 'package:reto/pages/portada.dart';

import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reto/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:reto/bloc/mapa/mapa_bloc.dart';

import './theme/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MultiProvider(
      providers: [
        BlocProvider(create: ( _ ) => MiUbicacionBloc(),),
        BlocProvider(create: ( _ ) => MapaBloc(),),
        ChangeNotifierProvider(create: (context) => DatosGlobales()),
      ],
      child: MaterialApp(
        home: PortadaPage(), //LLAMO A LA PORTADA
        theme: theme.getTheme(),
        debugShowCheckedModeBanner: false,
        routes: { //USO ESTAS RUTAS PARA COMPROBAR EL GPS
          'login'   : ( _ ) => LoginPage(),
          'loading' : ( _ ) => LoadingPage(),
          'portada' : ( _ ) => PortadaPage(),
        },
      ),
    );
  }
}
