import 'dart:convert';

rutasDataModelo rutasDataModeloJson(String str)=> rutasDataModelo.fromJson(json.decode(str));

String rutasDataModeloToJson(rutasDataModelo data) => json.encode(data.toJson());

//modelo de rutasData
class rutasDataModelo{
  String id;
  double lat;
  double lng;

  rutasDataModelo({this.id,this.lat,this.lng});

  factory rutasDataModelo.fromJson(Map<String,dynamic> json) => rutasDataModelo(
    id: json["_id"],
    lat: json["lat"],
    lng: json["lng"]
  );

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "lat": lat,
    "lng": lng

  };

  String get idRutasdDataModelo => id;

  double get latRutasdDataModelo => lat;

  double get lngRutasdDataModeloa => lng;


}