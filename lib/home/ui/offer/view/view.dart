import 'package:circle/app/app.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferListView extends StatelessWidget {
  final List<QueryDocumentSnapshot<OfferModal>> snapshot;
  final bool showHeaders;

  OfferListView(
    this.snapshot, {
    Key? key,
    this.showHeaders = true,
  }) : super(key: key);

  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    var list = snapshot;
    return StatefulBuilder(builder: (context, setState) {
      list.sort((a, b) => b.data().timestamp.compareTo(a.data().timestamp));
      return Column(children: [
        Container(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Search...'),
            onChanged: (value) {
              list = [];
              if (value.isEmpty) {
                list = snapshot;
              }
              // search offers
              else {
                list = snapshot.where((element) {
                  var search = element.data();
                  return (search.name ?? '').contains(value) ||
                      (search.description ?? '').contains(value) ||
                      search.keywords.any((search) => search.contains(value));
                }).toList();
              }
              setState(() => print('offer search updated'));
            },
          ),
          padding: EdgeInsets.all(12),
        ),
        Expanded(
          child: list.isEmpty
              ? Image.asset(
                  'assets/empty/offer.png',
                  fit: BoxFit.fitWidth,
                  width: _size.width,
                )
              : ListView(
                  padding: EdgeInsets.only(top: 6, bottom: 24),
                  children: list.map((snapshot) {
                    return OfferChildView(
                      snapshot,
                      showHeaders: showHeaders,
                    );
                  }).toList()),
        ),
      ]);
    });
  }
}

class OfferChildView extends StatelessWidget {
  final QueryDocumentSnapshot<OfferModal> snapshot;
  final bool showHeaders;
  final bool isView;

  OfferChildView(
    this.snapshot, {
    Key? key,
    this.showHeaders = true,
    this.isView = false,
  }) : super(key: key);

  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    var offer = snapshot.data();

    var isAdmin = profile.id == offer.createdBy;
    var photo = offer.photo;

    return InkWell(
      onTap: () => isView
          ? null
          : Navigator.pushNamed(
              context,
              VIEW_OFFER,
              arguments: snapshot,
            ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        showHeaders && isAdmin
            ? ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  VIEW_PROFILE,
                  arguments: profile.id,
                ),
                leading: Avatar(
                  photo: profile.getProfile,
                  avatarSize: 18,
                ),
                title: Text(
                  '${offer.name}'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${profile.getOrganizationName}'),
                      Text('${offer.getFormatDate()}'),
                    ]),
                trailing: InkWell(
                  onTap: () => launch('tel://${profile.phone}'),
                  child: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    radius: 15,
                    child: Icon(
                      Icons.call,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : showHeaders
                ? FutureBuilder(
                    future: db.profile.doc(offer.createdBy).get(),
                    builder: (_,
                        AsyncSnapshot<DocumentSnapshot<ProfileModal>>
                            snapshot) {
                      var profile = snapshot.data?.data();
                      return ListTile(
                        onTap: () => Navigator.pushNamed(
                          context,
                          VIEW_PROFILE,
                          arguments: profile?.id,
                        ),
                        leading: Avatar(
                          photo: profile?.getProfile,
                          avatarSize: 18,
                        ),
                        title: Text(
                          '${offer.name}'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${profile?.getOrganizationName}'),
                              Text('${offer.getFormatDate()}'),
                            ]),
                        trailing: InkWell(
                          onTap: () => launch('tel://${profile?.phone}'),
                          child: CircleAvatar(
                            backgroundColor: Colors.indigo,
                            radius: 15,
                            child: Icon(
                              Icons.call,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    })
                : SizedBox.shrink(),
        photo == null
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.grey.shade50.withOpacity(0.5),
                      BlendMode.dstATop,
                    ),
                    image: AssetImage('assets/message_bg.png'),
                    fit: BoxFit.fill,
                  ),
                  //color: Colors.blue[50],
                ),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(48, 48, 48, 162),
                child: Text('${offer.description}'),
              )
            : Image.network(photo),
        if (photo != null) Text('${offer.description}'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          TextButton.icon(
            onPressed: null,
            icon: Icon(
              Icons.visibility,
              color: offer.views.any((e) => e == profile.id)
                  ? Colors.green
                  : Colors.grey,
            ),
            label: Text('${offer.views.length}'),
          ),
          TextButton.icon(
            onPressed: null,
            icon: Icon(
              Icons.comment,
              color: offer.comments.any((e) => e == profile.id)
                  ? Colors.green
                  : Colors.grey,
            ),
            label: Text('${offer.comments.length}'),
          ),
          TextButton.icon(
            onPressed: () async {
              var likes = offer.likes;
              if (!likes.any((id) => id == profile.id)) {
                likes.add(profile.id ?? '');
                snapshot.reference.update({'likes': likes});
              }
            },
            icon: Icon(
              Icons.favorite,
              color: offer.likes.any((e) => e == profile.id)
                  ? Colors.green
                  : Colors.grey,
            ),
            label: Text('${offer.likes.length}'),
          ),
          if (!showHeaders && isAdmin) ...[
            IconButton(
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  EDIT_OFFER,
                  arguments: offer,
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue[300],
              ),
            ),
            IconButton(
              onPressed: () async {
                await snapshot.reference.delete();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.blue[300],
              ),
            ),
          ]
        ]),
        Divider(thickness: 6),
      ]),
    );
  }
}
