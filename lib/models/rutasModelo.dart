import 'dart:convert';

import 'package:reto/models/rutasDataModelo.dart';
import 'package:reto/models/rutasLocalizacionModelo.dart';


rutasModelo rutasModeloJson(String str)=> rutasModelo.fromJson(json.decode(str));

String rutasModeloToJson(rutasModelo data) => json.encode(data.toJson());

class rutasModelo{
  String id;
  String nombre;
  String ciudad;
  String imagen;
  double distancia;
  int tiempo;
  List<rutasDataModelo> rutas_data;
  List<rutasLocalizacionModelo> rutas_loc;

  rutasModelo({this.id,this.nombre,this.ciudad,this.imagen,this.distancia,this.tiempo,this.rutas_data,this.rutas_loc});

  factory rutasModelo.fromJson(Map<String,dynamic> json){
      var list = json['rutas_data'] as List;
      List<rutasDataModelo> lista = list.map((i) => rutasDataModelo.fromJson(i)).toList();
      
      var list2 = json['rutas_loc'] as List;
      List<rutasLocalizacionModelo> lista2 = list2.map((i) => rutasLocalizacionModelo.fromJson(i)).toList();

   return rutasModelo(
    id: json["_id"],
    nombre: json["nombre"],
    ciudad: json["ciudad"],
    imagen: json["imagen"],
    distancia: json["distancia"],
    tiempo: json["tiempo"],
    rutas_data: lista,
    rutas_loc: lista2,
  );

  }

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "nombre": nombre,
    "ciudad": ciudad,
    "imagen": imagen,
    "distancia": distancia,
    "tiempo": tiempo,
  };


}
