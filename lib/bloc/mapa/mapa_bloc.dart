import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reto/theme/map_theme.dart';

import '../../theme/map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {

  MapaBloc() : super(MapaState());

  //Controlador del mapa
  GoogleMapController _mapController;

  //Polylines
  Polyline _miRuta = new Polyline(
    polylineId: PolylineId('mi_ruta'), 
    color: Colors.cyan,
    width: 4,
  );

  //BuildContext context;

  // String _setStyle() {
  //   if(Theme.of(context).primaryColor == Colors.grey[900]) {
  //     return "mapTheme";
  //   } else {
  //     return "mapThemeLight";
  //   } 
  // }


  void initMapa(GoogleMapController controller){


      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(mapTheme));   
    
       add(OnMapaListo());
      }

  void initMapa2(GoogleMapController controller){


      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(mapThemeLight));   
    add(OnMapaListo());
      }
      
  void moverCamara(LatLng destino){
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event,) async* {

     if (event is OnNuevaUbicacion){
      yield* this._onNuevaUbicacion(event);

    } else if (event is OnMarcarRecorrido){
      yield* this._onMarcarRecorrido(event);
    
    } else if (event is OnSeguirUbicacion){
      yield* this._onSeguirUbicacion(event);

    } else if ( event is OnMovioMapa){
      print( event.centroMapa );
      yield state.copyWith( ubicacionCentral: event.centroMapa );

    }
  }

  Stream<MapaState> _onNuevaUbicacion(  OnNuevaUbicacion event ) async*{

    if( state.seguirUbicacion ){
      this.moverCamara(event.ubicacion);
    }

    final List<LatLng> points = [ ...this._miRuta.points, event.ubicacion ];
    this._miRuta = this._miRuta.copyWith( pointsParam: points );

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith( polylines: currentPolylines );

  }

  Stream<MapaState> _onMarcarRecorrido ( OnMarcarRecorrido event) async*{
    if( !state.dibujarRecorrido ){
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.cyan);
    }else{
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith( 
      polylines: currentPolylines,
      dibujarRecorrido: !state.dibujarRecorrido,
    );
  }

  Stream<MapaState> _onSeguirUbicacion (OnSeguirUbicacion event) async*{
    if(!state.seguirUbicacion){
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);

  }
}

