import 'package:circle/app/app.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatelessWidget {
  final db = FirestoreService();
  final list = <ProfileModal>[];

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Search'.toUpperCase())),
      body: FutureWidgetBuilder(
          future: getProfileModal(context, profile.id),
          builder: (List<ProfileModal>? data) {
            return StatefulBuilder(builder: (_, setState) {
              return Column(children: [
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Search...'),
                    onChanged: (value) {
                      list.clear();
                      if (value.isNotEmpty) {
                        data?.forEach((e) {
                          if (e.isExist(value)) list.add(e);
                        });
                      }
                      setState(() => print('search updated'));
                    },
                  ),
                  padding: EdgeInsets.all(12),
                ),
                Expanded(
                  child: list.isEmpty
                      ? Image.asset(
                          'assets/empty/search.jpg',
                          fit: BoxFit.fitWidth,
                          height: size.height,
                          width: size.width,
                        )
                      : ListView(
                          padding: EdgeInsets.all(12),
                          children: list.map(_view).toList(),
                        ),
                ),
              ]);
            });
          }),
    );
  }

  Widget _view(ProfileModal _profile) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: _profile.id == null
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  VIEW_PROFILE,
                  arguments: _profile.id,
                );
              },
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Avatar(
                  avatarSize: 18,
                  photo: _profile.profile,
                ),
                SizedBox(width: 9),
                Expanded(child: _subtitle(_profile)),
                Divider(thickness: 3),
                InkWell(
                  onTap: () => launch('tel://${_profile.phone}'),
                  child: CircleAvatar(
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
              Divider(thickness: 3),
            ]),
      );
    });
  }

  Widget _subtitle(ProfileModal _modal) {
    var location = _modal.businessLocation;
    var category = _modal.businessProfile.businessCategory;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  ${_modal.name}'.toUpperCase(),
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '  ${category}',
            maxLines: 1,
          ),
          if (!location.isEmpty)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.location_on, size: 18, color: Colors.green),
              Expanded(
                child: Text(
                  '${location.subLocality ?? ''} ${location.locality ?? ''} ${location.postalCode ?? ''}',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                  softWrap: true,
                ),
              ),
            ]),
        ]);
  }

  Future<List<ProfileModal>> getProfileModal(
    BuildContext context,
    String? id,
  ) async {
    var _circles = context.watch<List<QueryDocumentSnapshot<CircleModal>>>();

    var list = <ProfileModal>[];

    var createdBys = Set<String>();
    createdBys.add(id ?? 'null');

    await Future.forEach(_circles,
        (QueryDocumentSnapshot<CircleModal> circle) async {
      var members = await db.members(circle.reference).get();
      await Future.forEach(members.docs,
          (QueryDocumentSnapshot<ContactModal> member) async {
        var data = member.data();

        var referenceId = data.referenceId;
        if (referenceId != null)
          createdBys.add(referenceId);
        else {
          var pro = ProfileModal();

          pro.phoneNumber = data.phoneNumber;
          pro.countryCode = data.countryCode;
          pro.name = data.name;

          pro.businessProfile.businessCategory = data.category;
          if (!list.any((e) => e.phoneNumber == data.phoneNumber))
            list.add(pro);
        }
      });
      // circle all members list
    });

    if (createdBys.isNotEmpty) {
      var profile =
          await db.profile.where('id', whereIn: createdBys.toList()).get();

      profile.docs.forEach((e) => list.add(e.data()));
    }
    // all circle list
    return list;
  }
}
