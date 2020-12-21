import 'package:flutter/material.dart';
import 'package:reto/pages/registro.dart';
import 'package:reto/pages/home.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 100),
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:  AssetImage('images/logo.png')
                  )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  decoration: InputDecoration(
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
                    contentPadding: EdgeInsets.only(top: 22), // add padding to adjust text
                    hintText: "Password",
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                      child: Icon(Icons.lock, size: 20.0, color: Colors.cyan,),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 200, top: 3),
                child: Text('Forgot Password?')
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: RaisedButton(
                  color: Colors.cyan,
                  child: Text('LOGIN', style: TextStyle(fontSize: 16),),
                  padding: EdgeInsets.only(left: 150, right: 150),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
                  },
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('Login with')
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25, right: 10),
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text('GOOGLE', style: TextStyle(fontSize: 16),),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistroPage(),
                        ));
                      },
                    )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25,  left: 10),
                    child: RaisedButton(
                      color: Colors.cyan,
                      child: Text('TWITTER', style: TextStyle(fontSize: 16),),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistroPage(),
                        ));
                      },
                    )
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: InkWell(
                  child: Text('You dont have an account? SIGN UP'),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegistroPage(),
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