part of 'widgets.dart';

class BtnTipoMapa extends StatefulWidget {

  @override
  _BtnTipoMapaState createState() => _BtnTipoMapaState();
}

class _BtnTipoMapaState extends State<BtnTipoMapa> {
  @override
  Widget build(BuildContext context) {
// ignore: deprecated_member_use
    final mapaBloc = context.bloc<MapaBloc>();
    MapType _currentMapType = MapType.normal;

    return Container(
      alignment: FractionalOffset.bottomRight,
      margin: EdgeInsets.only(top: 330, right: 10),
      child: CircleAvatar(
        maxRadius: 28,
        backgroundColor: Colors.cyan,
        child: CircleAvatar(
          maxRadius: 25,
          child: IconButton(
            icon: Icon( Icons.satellite_outlined),
            onPressed: () {
              //Home().onMapTypeButtonPressed;
            },
          ),
        ),
      )
    );
  }
}