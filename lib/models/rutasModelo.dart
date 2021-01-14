import 'dart:convert';

import 'dart:ffi';

rutasModelo rutasModeloJson(String str)=> rutasModelo.fromJson(json.decode(str));

String rutasModeloToJson(rutasModelo data) => json.encode(data.toJson());

class rutasModelo{
  String nombre;
	String ciudad;
	String distancia;
  String tiempo;

  rutasModelo({this.nombre,this.ciudad,this.distancia,this.tiempo});

  factory rutasModelo.fromJson(Map<String,dynamic> json) => rutasModelo(
    nombre: json["nombre"],
    ciudad: json["ciudad"],
    distancia: json["distancia"],
    tiempo: json["tiempo"]
  );

  Map<String,dynamic> toJson()=>{
    "nombre": nombre,
    "ciudad": ciudad,
    "distancia": distancia,
    "tiempo": tiempo

  };

  String get nombreRuta => nombre;

  String get ciudadRuta => ciudad;

  String get distanciaRuta => distancia;

  String get tiempoRuta => tiempo;



}