part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final mapaBloc = context.bloc<MapaBloc>();

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, state){
        return Container(
          alignment: FractionalOffset.bottomRight,
          margin: EdgeInsets.only(top: 10, right: 10),
          child: CircleAvatar(
            backgroundColor: Colors.cyan,
            maxRadius: 28,
            child: CircleAvatar(
              maxRadius: 25,
              child: IconButton(
                icon: Icon( 
                  mapaBloc.state.seguirUbicacion //si seguirUbicacion es true
                    ? Icons.directions_run_outlined //true
                    : Icons.accessibility_new_outlined, //false
                ),
                onPressed: () {
                  mapaBloc.add(OnSeguirUbicacion());
                },
              ),
            ),
          )
        );
      }
    );
  }
}