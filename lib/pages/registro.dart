import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reto/theme/theme.dart';
import 'package:reto/models/usuarioModelo.dart';
import 'package:reto/theme/colors.dart';
import 'package:reto/globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'menu_ruta.dart';

class RegistroPage extends StatefulWidget {
  //PANTALLA DE REGISTRO
  @override
    Registro createState()=> Registro();
  }

//funcion que registra un usuario en la base de datos
  Future<usuarioModelo> registrarUsuario(String usuario, String password, String rol, String avatar) async{
    var Url = "${globals.ipLocal}/usuarios/nuevo";
    var response = await http.post(Url,headers:<String , String>{"Content-Type": "application/json"},
    body:jsonEncode(<String , String>{
      "usuario" : usuario,
      "password" : password,
      "rol": rol,
      "avatar": avatar
    }));
  }

class Registro extends State<RegistroPage>{

  String _usuario;

//funcion que devuelve todos los usuarios
  Future<List<usuarioModelo>> getUsuarios() async {
    var data = await http.get('${globals.ipLocal}/usuarios/todos');
    var jsonData = json.decode(data.body);

    List<usuarioModelo> usuario = [];
    for (var e in jsonData) {
      usuarioModelo usuarios = new usuarioModelo();
      usuarios.usuario = e["usuario"];
      usuario.add(usuarios);
    }
    return usuario;
  }

//validaciones del usuario
  String validarUsuario(String value) {
    if (value.isEmpty) {
      return "Rellena el campo";
    } else if (value.length < 3) {
      return "Tiene que tener como minimo 5 caracteres";
    } else if (value.length > 10) {
      return "Tiene que tener como maximo 10 caracteres";
    } else if(value == _usuario){
      return "El usuario ya existe";
    } else 
      return null;
  }

  File _imageFile; //PARA LA FOTO DE PERFIL
  final ImagePicker _picker = ImagePicker(); //PARA LA FOTO DE PERFIL
  File savedImage;

   GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController firstController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  usuarioModelo usuario;
  String guardarRuta = "";
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context); //PARA CAMBIAR EL TEMA

    String _setImage() { //CAMBIO EL LOGO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo.png";
      } else {
        return "images/logo2.png";
      } 
    }

    Icon _setIcon(){ //CAMBIO EL ICONO DEPENDIENDO DEL TEMA
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return Icon(Icons.bedtime_outlined);
      } else {
        return Icon(Icons.wb_sunny_outlined);
      }
    }

   Future<void> takePhoto(ImageSource source) async{ //FUNCION PARA LA FOTO DE PERFIL
      final pickedFile = await ImagePicker.pickImage(source: source, maxWidth: 600,);    

      setState((){
        _imageFile = pickedFile;
      });
      final appDir = await syspaths.getApplicationDocumentsDirectory();    
      final fileName = path.basename(_imageFile.path);    
      savedImage = await pickedFile.copy('${appDir.path}/$fileName'); 
    }

    Widget bottomSheet() { //FUNCION PARA LAS OPCIONES DE LA FOTO DE PERFIL
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Escoge tu Avatar",
              style: TextStyle(
                fontSize: 20.0
              ), 
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera_outlined),
                  onPressed: (){
                    takePhoto(ImageSource.camera);
                  },
                  label: Text("Camara")
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image_outlined),
                  onPressed: (){
                    takePhoto(ImageSource.gallery);
                  },
                  label: Text("Galeria")
                )
              ],
            )
          ]
        ),
      );
    }

    Widget imageProfile(){ //EL WIDGET DONDE SE COLOCARA LA FOTO DE PERFIL
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: 25),
          child: Stack(
            children: <Widget>[
               CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.cyan,
                child: CircleAvatar(
                  radius: 77.0,
                   backgroundImage: _imageFile == null
                    ? AssetImage("images/perfil.png")
                    : FileImage(File(_imageFile.path)),
                )            
              ),
              Positioned(
                bottom: 25.0,
                right: 25.0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context, 
                      builder: ((builder) => bottomSheet()),
                    );
                  },
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.cyan,
                    size: 28.0,
                  ),
                )
              )
            ],
          )
        ),
      );
    }

    return Scaffold( //EMPIEZA LA PANTALLA DEL REGISTRO
      appBar: AppBar(
        title: Text("REGISTRO"),
        centerTitle: true,
        actions: [
          IconButton( //CAMBIO EL TEMA SI SE PULSA EL ICONO
            icon: _setIcon(),
            onPressed: () => Theme.of(context).primaryColor == Colors.grey[900] ? _themeChanger.setTheme(ThemeData.light()) : _themeChanger.setTheme(ThemeData.dark())
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true, //comprueba validacion a tiempo real
          key: formkey,
          child: CustomPaint(
            painter: CurvePainter(context),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container( //LOGO
                    margin: EdgeInsets.only(top: 75),
                    height: 145,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // image:  AssetImage('images/logo.png')
                        image:  AssetImage(_setImage())
                      )
                    ),
                  ),
                  Container( //PRIMER CAMPO: USUARIO
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                    controller: firstController,
                     validator: validarUsuario,
                     onSaved: (String value){
                        _usuario = value;
                      },
                      decoration: InputDecoration(
                        // enabledBorder: UnderlineInputBorder(      
                        //   borderSide: BorderSide(color: Colors.cyan),   
                        // ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                        ),  
                        contentPadding: EdgeInsets.only(top: 22), // add padding to adjust text
                        hintText: "Usuario",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                          child: Icon(Icons.account_circle_outlined, size: 20.0, color: Colors.cyan,),
                        ),
                      ),
                        
                    ),
                  ),
                  Container( //SEGUNDO CAMPO: CONTRASEÑA
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: TextFormField(
                      obscureText: !_passwordVisible,
                      controller: secondController,
                      validator: MultiValidator([
                      RequiredValidator(errorText: "Rellena el campo"),
                      MinLengthValidator(8,errorText: "Tiene que tener como minimo 8 caracteres"),
                      MaxLengthValidator(12,errorText: "Tiene que tener como maximo 12 caracteres"), 
                    ]),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                        ), 
                        contentPadding: EdgeInsets.only(top: 22), // add padding to adjust text
                        hintText: "Password",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                          child: Icon(Icons.lock_outline, size: 20.0, color: Colors.cyan,),
                        ),
                        suffixIcon: IconButton(
                          icon: Padding(
                            padding: EdgeInsets.only(top: 12), // add padding to adjust icon
                            child: Icon(
                              _passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                              size: 25.0,
                              color: Colors.cyan,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                  _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                      ),
                    ),
                  ),
                  imageProfile(), //FOTO DE PERFIL
                  Container( 
                    //BOTON DE REGISTRO
                    margin: EdgeInsets.only(top: 25),
                    child: FutureBuilder(
                      future: getUsuarios(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return RaisedButton(
                          color: Colors.cyan,
                          child: Text('REGISTRO', style: TextStyle(fontSize: 16),),
                          padding: EdgeInsets.only(left: 136, right: 136),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onPressed: () async {
                            String usuario = firstController.text;
                            String password = secondController.text;
                            int cont = 0;
                            for(int i=0; i<snapshot.data.length; i++){
                              //print(snapshot.data[i].usuario);
                              if(snapshot.data[i].usuario == usuario){
                                formkey.currentState.save();
                                //print(_usuario);
                              }else{
                                if (formkey.currentState.validate()) {
                                    cont ++; 
                                    globals.usuario = usuario;
                                } else {
                                  print("Not Validated");        
                                }                
                              }
                              if(cont == snapshot.data.length){
                                if(savedImage == null){
                                    guardarRuta = "images/perfil.png";
                                }else{
                                  guardarRuta = savedImage.path;
                                }
                                usuarioModelo usuarios = await registrarUsuario(usuario, password, "1", guardarRuta);
                                firstController.text = '';
                                secondController.text = '';
                                setState(() {
                                  usuario = usuarios as String;
     
                                });
                                  globals.password = password;
                                  //print(savedImage.path);
                                  globals.avatar = guardarRuta;
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MenuRuta(),
                                  )
                                );  
                              }
                            }
                          },
                        );
                      }
                    )
                  ),
                ],
              )
            )
          )
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter{

  final BuildContext context ;
  CurvePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path = Path();
    path.lineTo(0, size.height*0.78);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.71);
    path.quadraticBezierTo(size.width*0.34, size.height*0.90, size.width*0.41, size.height*0.76);
    path.quadraticBezierTo(size.width*0.51, size.height*0.51, size.width*0.64, size.height*0.70);
    path.quadraticBezierTo(size.width*0.74, size.height*0.86, size.width, size.height*0.62);
    path.lineTo(size.width, 0);
    path.close();

    if(Theme.of(context).primaryColor == Colors.grey[900]) {
       paint.color = colorOne;
     }else{
       paint.color = colorTwo;
     }
    canvas.drawPath(path, paint);

    path =Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
    path.quadraticBezierTo(size.width*0.35, size.height*0.88, size.width*0.40, size.height*0.75);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.70);
    path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    if(Theme.of(context).primaryColor == Colors.grey[900]) {
       paint.color = colorThree;
     }else{
       paint.color = colorFour;
     }
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}