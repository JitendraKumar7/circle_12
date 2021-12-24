import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';

class ChooseCircle extends StatelessWidget {
  final db = FirestoreService();

  Future<List<QueryDocumentSnapshot<CircleModal>>> getProfileModal(BuildContext context) async {
    var _circles = context.watch<List<QueryDocumentSnapshot<CircleModal>>>();

    /*var list = <QueryDocumentSnapshot<CircleModal>>[];

    await Future.forEach(_circles.docs,
        (QueryDocumentSnapshot<CircleModal> circle) async {
      var _reference = circle.reference;

      var _members =
          await db.members(_reference).doc(_profile.phoneNumber).get();
      if (_members.exists) {
        list.add(circle);
      }

      // circle all members list
    });*/

    return _circles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SELECT ANY CIRCLE')),
      body: FutureWidgetBuilder(
          future: getProfileModal(context),
          builder: (List<QueryDocumentSnapshot<CircleModal>>? data) {
            var list1 = data ?? <QueryDocumentSnapshot<CircleModal>>[];
            return ListView(
              padding: EdgeInsets.all(12),
              children: list1.map((e) {
                var circle = e.data();
                var photo = circle.profile;
                return Column(children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: (photo == null
                              ? AssetImage('assets/default/circle.jpg')
                              : NetworkImage(photo)) as ImageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      ADD_CONTACT,
                      arguments: e,
                    ),
                    title: Text('${circle.name}'),
                    subtitle: Text('${circle.type}'),
                  ),
                  Divider(thickness: 3)
                ]);
              }).toList(),
            );
          }),
    );
  }
}
