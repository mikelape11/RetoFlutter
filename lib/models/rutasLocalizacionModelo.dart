import 'dart:convert';

rutasLocalizacionModelo rutasLocalizacionModeloJson(String str)=> rutasLocalizacionModelo.fromJson(json.decode(str));

String rutasLocalizacionModeloToJson(rutasLocalizacionModelo data) => json.encode(data.toJson());

//modelo rutasLocalizacion
class rutasLocalizacionModelo{
  String id;
  double lat;
  double lng;

 rutasLocalizacionModelo({this.id,this.lat,this.lng});

  factory rutasLocalizacionModelo.fromJson(Map<String,dynamic> json) => rutasLocalizacionModelo(
    id: json["_id"],
    lat: json["lat"],
    lng: json["lng"]
  );

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "lat": lat,
    "lng": lng

  };

  String get idRutasLocalizacionModelo => id;

  double get latRutasLocalizacionModelo => lat;

  double get lngRutasLocalizacionModelo => lng;


}