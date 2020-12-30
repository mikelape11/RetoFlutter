part of 'helpers.dart';

Route navegarMapaFadeIn(BuildContext context, Widget page){ //ANIMACION PARA LA TRANSICICION (NO SE VE, PERO ME LA PELA)
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, _, child) {

      return FadeTransition(
        child: child,
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut)
        )
      );
    },
  );
}