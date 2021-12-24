import 'package:circle/app/app.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';

class XplorePage extends StatefulWidget {
  @override
  State<XplorePage> createState() => _XploreState();
}

class _XploreState extends State<XplorePage> {
  var db = FirestoreService();
  late ProfileModal profile;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    profile = context.read<ProfileModal>();
    return FutureWidgetBuilder(
        future: getCircleList(),
        builder: (List<QueryDocumentSnapshot<CircleModal>>? snapshot) {
          var list = snapshot ?? [];
          return StatefulBuilder(builder: (_, setState) {
            return Column(children: [
              Container(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'Search...'),
                  onChanged: (value) {
                    list = [];
                    if (value.isEmpty) {
                      list = snapshot ?? [];
                    }
                    // search offers
                    else {
                      (snapshot ?? []).forEach((e) {
                        var circle = e.data();
                        bool name = circle.name
                                ?.toLowerCase()
                                .contains(value.toLowerCase()) ??
                            false;
                        bool description = circle.description
                                ?.toLowerCase()
                                .contains(value.toLowerCase()) ??
                            false;
                        if (name || description) list.add(e);
                      });
                    }
                    setState(() => print('xplore search updated'));
                  },
                ),
                padding: EdgeInsets.all(12),
              ),
              Expanded(
                child: list.isEmpty
                    ? Image.asset(
                        'assets/empty/search.jpg',
                        fit: BoxFit.fitWidth,
                        width: _size.width,
                      )
                    : ListView(
                        children: list
                            .map((item) => CircleItemView(item, setState))
                            .toList(),
                      ),
              ),
            ]);
          });
        });
  }

  Future<List<QueryDocumentSnapshot<CircleModal>>> getCircleList() async {
    var _circles = await db.circle.where('type', isEqualTo: 'Social').get();

    _circles.docs.forEach((doc) {
      var data = doc.data();
      if (data.references.isEmpty || data.members.isEmpty) {
        doc.reference.delete();
      }
    });

    return _circles.docs.where((doc) {
      var data = doc.data();
      var request = data.request.any((e) => e == profile.id);
      var members = data.members.any((e) => e == profile.phoneNumber);
      return !members && !request;
    }).toList();
  }
}

class CircleItemView extends StatelessWidget {
  final QueryDocumentSnapshot<CircleModal> snapshot;
  final db = FirestoreService();
  final StateSetter setState;

  CircleItemView(
    this.snapshot,
    this.setState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    var size = MediaQuery.of(context).size;

    var circle = snapshot.data();
    var photo = circle.profile;
    return Card(
      elevation: 6,
      color: Colors.white,
      shape: CircleBorder(),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Container(
        width: size.width,
        height: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5),
              BlendMode.dstATop,
            ),
            image: (photo == null
                ? AssetImage('assets/default/circle.jpg')
                : NetworkImage(photo)) as ImageProvider,
            fit: BoxFit.fill,
          ),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FutureBuilder(
              future: db.profile.doc(circle.createdBy).get(),
              builder:
                  (_, AsyncSnapshot<DocumentSnapshot<ProfileModal>> snapshot) {
                var data = snapshot.data?.data();
                return Column(children: [
                  Avatar(
                    photo: data?.profile,
                    avatarSize: 24,
                  ),
                  Text(
                    '${data?.name ?? 'Admin'}'.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ]);
              }),
          _showName('${circle.name}'),
          _showDescription('${circle.description}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: db.offers
                    .where('createdBy', whereIn: circle.references)
                    .get(),
                builder:
                    (_, AsyncSnapshot<QuerySnapshot<OfferModal>> snapshot) {
                  var offers = snapshot.data?.size ?? 0;
                  return _cardButton(
                    size.width / 5,
                    Icons.local_offer,
                    '$offers Offers',
                  );
                },
              ),
              _cardButton(
                size.width / 5,
                Icons.group,
                '${circle.members.length}',
              ),
              // Share Circle
              _cardButton(
                size.width / 5,
                Icons.share,
                'Share',
              ),
            ],
          ),
          ElevatedButton(
            onPressed: circle.request.any((id) => id == profile.id)
                ? null
                : () async {
                    /*\
                    var _contact = ContactModal(
                      phoneNumber: profile.phoneNumber,
                      countryCode: profile.countryCode,
                      category: profile.businessProfile.businessCategory,
                      reference: _modal.profile.id,
                      referenceId: profile.id,
                      name: profile.name,
                    );
                    _modal.requests.add(profile.id);
                    var phoneNumber = profile.phoneNumber;
                    _showSnackBar(context, 'Request Send Successfully');
                    db.request(_modal.reference).doc(phoneNumber).set(_contact);
                    setState(() => print('reload'));
                    */
                    var _result = await Navigator.pushNamed(
                      context,
                      CONTACT_REQUEST,
                      arguments: snapshot,
                    );
                    if (_result != null) setState(() => print('reload'));
                  },
            child: Text('REQUEST TO JOIN'),
          ),
        ]),
      ),
    );
  }

  Widget _showDescription(String text) =>
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          ),
        ),
        if (text.length > 75)
          Builder(
            builder: (BuildContext context) => InkWell(
              onTap: () {
                var messenger = ScaffoldMessenger.of(context);
                messenger.showMaterialBanner(
                  MaterialBanner(
                    forceActionsBelow: true,
                    content: Text(text),
                    actions: <Widget>[
                      Text(text),
                      TextButton(
                        child: Text('DISMISS'),
                        onPressed: () {
                          messenger.removeCurrentMaterialBanner();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'more...',
                style: TextStyle(color: Colors.grey[300]),
              ),
            ),
          ),
      ]);

  Widget _cardButton(
    double? size,
    IconData? icon,
    String text,
  ) =>
      Card(
        color: Colors.white,
        shape: CircleBorder(),
        margin: EdgeInsets.all(6),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              icon,
              size: 18,
              color: Color(0xFF3B5998),
            ),
            Text(
              text,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF3B5998),
              ),
            ),
          ]),
        ),
      );

  Widget _showName(String name) => Container(
        width: double.infinity,
        alignment: Alignment.center,
        height: 40,
        margin: EdgeInsets.only(top: 12, bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue.shade100,
            Colors.blue.shade700,
            Colors.blue.shade400,
            Colors.blue.shade200,
            Colors.blue.shade100,
          ]),
        ),
        child: Center(
          child: Text(
            name.toUpperCase(),
            maxLines: 1,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
