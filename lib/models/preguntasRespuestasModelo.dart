import 'dart:convert';


preguntasRespuestasModelo preguntasRespuestasModeloJson(String str)=> preguntasRespuestasModelo.fromJson(json.decode(str));

String preguntasRespuestasModeloToJson(preguntasRespuestasModelo data) => json.encode(data.toJson());

class preguntasRespuestasModelo{
  String id;
  int numRespeusta;
  String respuesta;

  preguntasRespuestasModelo({this.id,this.numRespeusta,this.respuesta});

  factory preguntasRespuestasModelo.fromJson(Map<String,dynamic> json){
   return preguntasRespuestasModelo(
    id: json["_id"],
    numRespeusta: json["numRespeusta"],
    respuesta: json["respuesta"],
  );

  }

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "numRespeusta": numRespeusta,
    "respuesta": respuesta,
  };


}
