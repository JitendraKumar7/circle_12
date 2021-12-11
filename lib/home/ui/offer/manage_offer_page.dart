import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'view/view.dart';

class ManageOfferPage extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    return Scaffold(
      body: FutureWidgetBuilder(
          future: createdBys(profile),
          builder: (List<String>? createdBys) {
            return StreamWidgetBuilder(
              stream: db.offers
                  .where('createdBy', whereIn: createdBys ?? [])
                  .snapshots(),
              builder: (QuerySnapshot<OfferModal>? offers) {
                print('offers ${offers?.size}');
                return OfferListView(
                  offers?.docs ?? [],
                  showHeaders: false,
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var _result = await Navigator.pushNamed(context, ADD_OFFER);
        },
      ),
    );
  }

  Future<List<String>> createdBys(ProfileModal profile) async {
    var _circles = await db.circle
        .where('members', arrayContains: profile.phoneNumber)
        .get();

    var createdBys = Set<String>();
    createdBys.add(profile.id ?? '');

    await Future.forEach(_circles.docs.map((e) => e.data()),
        (CircleModal modal) async {
      createdBys.addAll(modal.references);
    });
    print('createdBys $createdBys');
    return createdBys.skipWhile((value) => value.isEmpty).toList();
  }
}
