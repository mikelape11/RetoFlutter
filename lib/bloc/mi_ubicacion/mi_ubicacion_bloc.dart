import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  StreamSubscription<Geolocator.Position> _positionSubscription;

  void iniciarSeguimiento(){

    // final geoLocatorOptions = Geolocator.LocationOptions(
    //   accuracy: Geolocator.LocationAccuracy.high,
    //   distanceFilter: 10,
    // );

    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: Geolocator.LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Geolocator.Position position) {
      print(position);
      final nuevaUbicacion = new LatLng(position.latitude, position.longitude);
      add(OnUbicacionCambio( nuevaUbicacion ));
    });

  }

  void cancerlarSeguimiento(){
    _positionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState( MiUbicacionEvent event,) async* {
    if( event is OnUbicacionCambio){
      print(event);
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion,
      );
    }
  }
}
