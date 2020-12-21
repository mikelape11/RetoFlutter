import 'package:flutter/material.dart';
import 'package:reto/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:reto/theme/theme.dart';

class RegistroPage extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    String _setImage() {
      if(Theme.of(context).primaryColor == Colors.grey[900]) {
        return "images/logo.png";
      } else {
        return "images/logo2.png";
      } 
    }

    Widget imageProfile(){
      return Center(
        child: Container(
          margin: EdgeInsets.only(top: 25),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage("images/logo.png"),
              ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: InkWell(
                  onTap: () {},
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

    return new Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
        actions: [
          IconButton(
            icon: Icon(Icons.bedtime),
            onPressed: () => _themeChanger.setTheme(ThemeData.dark())
          ),
          IconButton(
            icon: Icon(Icons.wb_sunny_outlined),
            onPressed: () => _themeChanger.setTheme(ThemeData.light())
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 90),
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image:  AssetImage('images/logo.png')
                    image:  AssetImage(_setImage())
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
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
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  decoration: InputDecoration(
                    // enabledBorder: UnderlineInputBorder(      
                    //   borderSide: BorderSide(color: Colors.cyan),   
                    // ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan, width: 2.0),
                    ),  
                    contentPadding: EdgeInsets.only(top: 22), // add padding to adjust text
                    hintText: "Email",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                      child: Icon(Icons.email_outlined, size: 20.0, color: Colors.cyan,),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
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
                  ),
                ),
              ),
              imageProfile(),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('REGISTRO', style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.only(left: 136, right: 136),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                )
              ),
            ],
          )
        )
      )
    );
  }
}