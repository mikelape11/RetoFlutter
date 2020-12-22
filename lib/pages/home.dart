import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reto/theme/theme.dart';

class HomePage extends StatefulWidget {

@override
  Home createState()=> Home();
}
class Home extends State<HomePage>{
  PickedFile _imageFile;
  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    final List<Widget> children = _widgetOptions( );
    return new Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
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
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [ 
                Container(
                  //child: _widgetOptions.elementAt(_selectedIndex),
                  child: children[_selectedIndex],
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Ranking',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
  
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  List<Widget> _widgetOptions() => [
    Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            messageListArea(),
            submitArea(),
            // Text(
            //   'SOY CHAT', 
            //   style: optionStyle,
            // )
          ],
        )
      ),
    ),
    Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: Text(
              'SOY MAPA',
              style: optionStyle,
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          children: <Widget>[
            Text(
              'CLASIFICACIÓN EN DIRECTO',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Row(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 0, top: 110),
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.cyan,
                        child: CircleAvatar(
                          radius: 57.0,
                          backgroundImage: _imageFile == null
                            ? AssetImage("images/perfil.png")
                            : FileImage(File(_imageFile.path)),
                        )            
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 222, top: 110),
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.cyan,
                        child: CircleAvatar(
                          radius: 57.0,
                          backgroundImage: _imageFile == null
                            ? AssetImage("images/perfil.png")
                            : FileImage(File(_imageFile.path)),
                        )            
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 84.0),
                      child:  CircleAvatar(
                        radius: MediaQuery.of(context).size.width/4.5,
                        backgroundColor: Colors.cyan,
                        child: CircleAvatar(
                          radius:  MediaQuery.of(context).size.width/4.7,
                          backgroundImage: _imageFile == null
                            ? AssetImage("images/perfil.png")
                            : FileImage(File(_imageFile.path)),
                        )            
                      ),
                    ),
                  ],
                ),
                
               
                
              ])
            ), 
          ],
        )
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget messageListArea() {
    return Container(
      height: 500,
    );
  }

  Widget submitArea() {
    return SizedBox(
      width: 350.0,
      height: 70.0,
      child: Card(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15.0),
      //   side: BorderSide(
      //     color: Colors.grey,
      //     width: 2.0,
      //   ),
      // ),
        child: ListTile(
          contentPadding: EdgeInsets.only(bottom: 5, left: 20),
          title: TextFormField(
            decoration: InputDecoration(
              hintText: "Escribe un mensaje",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan, width: 2.0),
              ),
            ),
            //controller: msgCon,
            
          ),
          
          trailing: IconButton(
            
            icon: Icon(Icons.send),
            color: Colors.cyan,
            disabledColor: Colors.grey,
            //onPressed: (socket != null) ? submitMessage : null,
          ),
        ),
      ),
    );
  }

  
}