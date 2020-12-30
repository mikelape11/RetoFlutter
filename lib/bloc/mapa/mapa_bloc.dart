import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reto/theme/map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {

  MapaBloc() : super(MapaState());

  GoogleMapController _mapController;

  void initMapa(GoogleMapController controller){

    if ( !state.mapaListo ){
      this._mapController = controller;
      this._mapController.setMapStyle(jsonEncode(mapTheme));   

      add(OnMapaListo());
    }

      //this._mapController.setMapStyle(jsonEncode(mapThemeLight));
      //this._mapController.setMapStyle(jsonEncode(mapTheme));   
  }

  void moverCamara(LatLng destino){
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event,) async* {

    if( event is OnMapaListo){
      yield state.copyWith(mapaListo: true);
    }

  }
}
