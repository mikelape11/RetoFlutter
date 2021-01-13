import 'package:flutter/material.dart';
import 'package:reto/widgets/sliding_card.dart';

class SlidingCardsView extends StatefulWidget {
  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;

 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.68,  //<-- set height of the card
      child: PageView(
        controller: pageController,
        children: <Widget>[
           SlidingCard(
            name: 'Irún',
            date: '2 Horas',
            assetName: 'irun.jpg',
          ),
          SlidingCard(
            name: 'Irún - Hendaia',
            date: '2 Horas y Media',
            assetName: 'hendaia.jpg',
          ),
          SlidingCard(
            name: 'Donosti 1',
            date: '2 Horas',
            assetName: 'donosti1.jpg',
          ),
          SlidingCard(
            name: 'Donosti 2',
            date: '3 Horas',
            assetName: 'donosti2.jpg',
          ),
        ],
      ),
    );
  }
}
