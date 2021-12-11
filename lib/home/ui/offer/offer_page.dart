import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
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
      /*body: FutureWidgetBuilder(
          future: getOffersList(),
          builder: (List<OfferListModal>? data) {
            var list1 = data ?? [];
            var list2 = data ?? [];
            return StatefulBuilder(builder: (_, setState) {
              return Column(children: [
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Search...'),
                    onChanged: (value) {
                      list1 = [];
                      if (value.isEmpty) {
                        list1 = list2;
                      }
                      // search offers
                      else {
                        list2.forEach((e) {
                          bool name = e.offer.name
                                  ?.toLowerCase()
                                  .contains(value.toLowerCase()) ??
                              false;
                          bool description = e.offer.description
                                  ?.toLowerCase()
                                  .contains(value.toLowerCase()) ??
                              false;
                          if (name || description) list1.add(e);
                        });
                      }
                      setState(() => print('offer search updated'));
                    },
                  ),
                  padding: EdgeInsets.all(12),
                ),
                Expanded(
                  child: list1.isEmpty
                      ? Image.asset(
                          'assets/empty/offer.png',
                          fit: BoxFit.fitWidth,
                          width: _size.width,
                        )
                      : ListView(
                          padding: EdgeInsets.only(top: 6, bottom: 24),
                          children: list1
                              .map((modal) => ViewOffers(
                                    profile: profile,
                                    modal: modal,
                                  ))
                              .toList()),
                ),
              ]);
            });
          }),*/
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var _result = await Navigator.pushNamed(context, ADD_OFFER);
          //if (_result != null) setState(() => print('pushNamed ADD_OFFER'));
        },
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
