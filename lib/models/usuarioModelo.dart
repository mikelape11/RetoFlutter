import 'dart:convert';

usuarioModelo usuarioModeloJson(String str)=> usuarioModelo.fromJson(json.decode(str));

String usuarioModeloToJson(usuarioModelo data) => json.encode(data.toJson());

//modelo de usuario
class usuarioModelo{
  String id;
  String usuario;
	String password;
	String rol;
  String avatar;

  usuarioModelo({this.id,this.usuario,this.password,this.rol,this.avatar});

  factory usuarioModelo.fromJson(Map<String,dynamic> json) => usuarioModelo(
    id: json["_id"],
    usuario: json["usuario"],
    password: json["password"],
    rol: json["rol"],
    avatar: json["avatar"]
  );

  Map<String,dynamic> toJson()=>{
    "_id": id,
    "usuario": usuario,
    "password": password,
    "rol": rol,
    "avatar": avatar
  };

  String get idUsuario => id;

  String get nombreUsuario => usuario;

  String get contrasena => password;

  String get rolUsuario => rol;

  String get avatarUsuario => avatar;

}