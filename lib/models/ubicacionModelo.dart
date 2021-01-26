import 'dart:convert';

ubicacionModelo ubicacionModeloJson(String str)=> ubicacionModelo.fromJson(json.decode(str));

String ubicacionModeloToJson(ubicacionModelo data) => json.encode(data.toJson());

class ubicacionModelo{
  String id;
  double lat;
  double lng;
  String rutaId;

 ubicacionModelo({this.id,this.lat,this.lng,this.rutaId});

  factory ubicacionModelo.fromJson(Map<String,dynamic> json) => ubicacionModelo(
    id: json["_id"],
    lat: json["lat"],
    lng: json["lng"],
    rutaId: json["rutaId"],
  );

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "lat": lat,
    "lng": lng,
    "rutaId": rutaId,

  };

  String get idubicacionModelo => id;

  double get latubicacionModelo => lat;

  double get lngubicacionModelo => lng;

  String get rutaIdbicacionModelo => rutaId;


}