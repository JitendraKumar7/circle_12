import 'package:circle/home/ui/offer/view/view.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/material.dart';

class ListOfferPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    var offers = args as QuerySnapshot<OfferModal>;
    return Scaffold(
      appBar: AppBar(title: Text('List Offer'.toUpperCase())),
      body: OfferListView(offers.docs),
    );
  }
}
