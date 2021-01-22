import 'dart:convert';

import 'package:reto/models/preguntasRespuestasModelo.dart';



preguntasModelo preguntasModeloJson(String str)=> preguntasModelo.fromJson(json.decode(str));

String preguntasModeloToJson(preguntasModelo data) => json.encode(data.toJson());

class preguntasModelo{
  String id;
  int numPregunta;
  String pregunta;
  List<preguntasRespuestasModelo> respuestas;
  String rutasId;
  int opcion;

  preguntasModelo({this.id,this.numPregunta,this.pregunta,this.respuestas,this.rutasId,this.opcion});

  factory preguntasModelo.fromJson(Map<String,dynamic> json){
      var list = json['respuestas'] as List;
      List<preguntasRespuestasModelo> lista = list.map((i) => preguntasRespuestasModelo.fromJson(i)).toList();

   return preguntasModelo(
    id: json["_id"],
    numPregunta: json["numPregunta"],
    pregunta: json["pregunta"],
    respuestas: lista,
    rutasId: json["rutasId"],
    opcion: json["opcion"],
  
  );

  }

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "numPregunta": numPregunta,
    "pregunta": pregunta,
    "rutasId": rutasId,
    "opcion": opcion,
  };


}
