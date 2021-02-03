import 'dart:convert';

rankingModelo rankingModeloJson(String str)=> rankingModelo.fromJson(json.decode(str));

String rankingModeloToJson(rankingModelo data) => json.encode(data.toJson());

//modelo de ranking
class rankingModelo{
  String id;
  int puntos;
	String usuario_id;
	String nombre;
  int aciertos;
  int fallos;
  int tiempo;
  String rutasId;

  rankingModelo({this.id,this.puntos,this.usuario_id,this.nombre,this.aciertos,this.fallos,this.tiempo,this.rutasId});

  factory rankingModelo.fromJson(Map<String,dynamic> json) => rankingModelo(
    id: json["_id"],
    puntos: json["puntos"],
    usuario_id: json["usuario_id"],
    nombre: json["nombre"],
    aciertos: json["aciertos"],
    fallos: json["fallos"],
    tiempo: json["tiempo"],
    rutasId: json["rutasId"]

  );

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "puntos": puntos,
    "usuario_id": usuario_id,
    "nombre": nombre,
    "aciertos": aciertos,
    "fallos": fallos,
    "tiempo": tiempo,
    "rutasId": rutasId,
  };

  String get idRanking => id;

  int get puntosRanking => puntos;

  String get usuario_idRanking => usuario_id;

  String get nombreRanking => nombre;

  int get aciertosRanking => aciertos;

  int get fallosRanking => fallos;

  int get tiempoRanking => tiempo;

  String get rutas_idRanking => rutasId;

}