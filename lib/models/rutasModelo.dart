import 'dart:convert';

import 'package:reto/models/rutasDataModelo.dart';

rutasModelo rutasModeloJson(String str)=> rutasModelo.fromJson(json.decode(str));

String rutasModeloToJson(rutasModelo data) => json.encode(data.toJson());

class rutasModelo{
  String id;
  String nombre;
  String ciudad;
  double distancia;
  int tiempo;
  List<rutasDataModelo> rutas_data;

  rutasModelo({this.id,this.nombre,this.ciudad,this.distancia,this.tiempo,this.rutas_data});

  factory rutasModelo.fromJson(Map<String,dynamic> json){
      var list = json['rutas_data'] as List;
      List<rutasDataModelo> lista = list.map((i) => rutasDataModelo.fromJson(i)).toList();

   return rutasModelo(
    id: json["_id"],
    nombre: json["nombre"],
    ciudad: json["ciudad"],
    distancia: json["distancia"],
    tiempo: json["tiempo"],
    rutas_data: lista,
  );

  }

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "nombre": nombre,
    "ciudad": ciudad,
    "distancia": distancia,
    "tiempo": tiempo,
  };


}