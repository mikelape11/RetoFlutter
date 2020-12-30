part of 'widgets.dart';

class BtnUbicacion extends StatelessWidget {
  //BOTON PARA CENTRAR LA UBICACION DEL USUARIO
  @override
  Widget build(BuildContext context) {

    final mapaBloc = context.bloc<MapaBloc>();
    final miUbicacionBloc = context.bloc<MiUbicacionBloc>();

    return Container(
      alignment: FractionalOffset.bottomRight,
      margin: EdgeInsets.only(top: 540, right: 10),
      child: CircleAvatar(
        maxRadius: 28,
        backgroundColor: Colors.cyan,
        child: CircleAvatar(
          maxRadius: 25,
          child: IconButton(
            icon: Icon( Icons.my_location_outlined),
            onPressed: () {
              final destino = miUbicacionBloc.state.ubicacion;
              mapaBloc.moverCamara(destino);
            },
          ),
        )
      ),
    );
  }
}