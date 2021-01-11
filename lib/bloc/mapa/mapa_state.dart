part of 'mapa_bloc.dart';

@immutable
class MapaState{

  final bool dibujarRecorrido;
  final bool seguirUbicacion;

  final LatLng ubicacionCentral;

  final Map<String, Polyline> polylines;

  MapaState({
    this.dibujarRecorrido = true,
    this.seguirUbicacion = false,
    this.ubicacionCentral,
    Map<String, Polyline> polylines
  }): this.polylines = polylines ?? new Map();

  copyWith({
    bool dibujarRecorrido,
    bool seguirUbicacion,
    LatLng ubicacionCentral,
    Map<String, Polyline> polylines
  }) => MapaState(
    dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
    polylines: polylines ?? this.polylines,
    seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
    ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
    
  );

}
