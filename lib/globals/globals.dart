library my_prj.globals;

import 'dart:io';

import 'package:dash_chat/dash_chat.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String id = "";
bool isLogged = false;
String usuario = "";
String password = "";
String avatar = "";
bool existeAvatar = false;
LatLng nuevaUbicacion = new LatLng(0, 0);
String ipBase = "http://137.135.163.214:8080/Reto";
String ipLocal = "http://10.0.2.2:8080";
String idRuta = "";
int posicionPregunta = 0;
bool colorMarker = false;
String idRanking = "";
String idUsuario = "";
String idUbicacion = "";
int puntuacionTotal = 0;
int aciertos = 0;
int fallos = 0;

bool conectado = false;
String ipChat = "10.0.2.2";
Socket socket;
int puerto = 1234;
var mensajes = List<ChatMessage>();


