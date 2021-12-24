import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';

import 'view/view.dart';

class OfferPage extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    db.profileUpdate(profile.id, 'offerCounter');
    if (profile.offerCounter > 0) {
      profile.offerCounter = 0;
      profile.listeners();
    }
    return Scaffold(
      body: FutureWidgetBuilder(
          future: createdBys(context, profile.id),
          builder: (List<String>? createdBys) {
            return StreamWidgetBuilder(
              stream: db.offers
                  .where('createdBy', whereIn: createdBys ?? [])
                  .snapshots(),
              builder: (QuerySnapshot<OfferModal>? offers) {
                print('offers ${offers?.size}');
                return OfferListView(offers?.docs ?? []);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, ADD_OFFER),
      ),
    );
  }

  Future<List<String>> createdBys(BuildContext context, String? id) async {
    var _circles = context.watch<List<QueryDocumentSnapshot<CircleModal>>>();

    var createdBys = Set<String>();
    createdBys.add(id ?? 'null');

    await Future.forEach(_circles.map((e) => e.data()),
        (CircleModal modal) async {
      createdBys.addAll(modal.references);
    });
    print('createdBys $createdBys');
    return createdBys.skipWhile((value) => value.isEmpty).toList();
  }
}
