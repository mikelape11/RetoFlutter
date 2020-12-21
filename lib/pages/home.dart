import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

@override
  Home createState()=> Home();
}
class Home extends State<HomePage>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  List<Widget> _widgetOptions() => [
    Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'SOY CHAT', 
              style: optionStyle,
            )
          ],
        )
      ),
    ),
    Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Text(
          'SOY MAPA',
          style: optionStyle,
        ),
      ),
    ),
    Center(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Text(
          'SOY RANKING',
          style: optionStyle,
        ),
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _widgetOptions( );
    return new Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
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
}