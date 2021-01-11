part of 'widgets.dart';

class BtnLineaRuta extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
// ignore: deprecated_member_use
    final mapaBloc = context.bloc<MapaBloc>();

    return Container(
      alignment: FractionalOffset.bottomRight,
      margin: EdgeInsets.only(top: 400, right: 10),
      child: CircleAvatar(
        maxRadius: 28,
        backgroundColor: Colors.cyan,
        child: CircleAvatar(
          maxRadius: 25,
          child: IconButton(
            icon: Icon( Icons.alt_route_outlined),
            onPressed: () {
              mapaBloc.add(OnMarcarRecorrido());
            },
          ),
        ),
      )
    );
  }
}