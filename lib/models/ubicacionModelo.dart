import 'dart:convert';

ubicacionModelo ubicacionModeloJson(String str)=> ubicacionModelo.fromJson(json.decode(str));

String ubicacionModeloToJson(ubicacionModelo data) => json.encode(data.toJson());


//modelo de ubicacion
class ubicacionModelo{
  String id;
  String nombreUsuario;
  double lat;
  double lng;
  String rutaId;

 ubicacionModelo({this.id,this.nombreUsuario,this.lat,this.lng,this.rutaId});

  factory ubicacionModelo.fromJson(Map<String,dynamic> json) => ubicacionModelo(
    id: json["_id"],
    nombreUsuario: json["nombreUsuario"],
    lat: json["lat"],
    lng: json["lng"],
    rutaId: json["rutaId"],
  );

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "nombreUsuario": nombreUsuario,
    "lat": lat,
    "lng": lng,
    "rutaId": rutaId,

  };

  String get idubicacionModelo => id;

  String get nombreUsuarioUbicacionModelo => nombreUsuario;

  double get latubicacionModelo => lat;

  double get lngubicacionModelo => lng;

  String get rutaIdbicacionModelo => rutaId;


}