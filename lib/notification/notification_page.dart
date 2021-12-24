import 'dart:async';

import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  var db = FirestoreService();
  late ProfileModal _profile;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var db = FirestoreService();
      var profile = context.read<ProfileModal>();
      db.profileUpdate(profile.id, 'notificationCounter');

      if (profile.notificationCounter > 0) {
        profile.notificationCounter = 0;
        profile.listeners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _profile = context.read<ProfileModal>();
    var _size = MediaQuery.of(context).size;
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notification'.toUpperCase()),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              child: Text(
                'INFORMATION',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.history,
                color: Colors.white,
              ),
              child: Text(
                'REQUESTS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          StreamBuilder(
              stream: db.notifications
                  .where('viewerId', isEqualTo: _profile.id)
                  //.orderBy('timestamp')
                  .snapshots(),
              builder:
                  (_, AsyncSnapshot<QuerySnapshot<Notifications>> snapshot) {
                var list = snapshot.data?.docs ?? [];
                var data = list.map((e) => e.data()).toList();
                data.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                return data.isEmpty
                    ? Image.asset(
                        'assets/empty/notification.jpg',
                        fit: BoxFit.fitWidth,
                        width: _size.width,
                      )
                    : ListView(children: data.map(loadNotifications).toList());
              }),
          FutureWidgetBuilder(
              future: getRequestList(),
              builder: (List<CircleRequestModal>? data) {
                return (data ?? []).isEmpty
                    ? Image.asset(
                        'assets/empty/notification.jpg',
                        fit: BoxFit.fitWidth,
                        width: _size.width,
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        itemCount: data?.length ?? 0,
                        itemBuilder: (_, int i) => requestView(data![i]),
                        separatorBuilder: (_, __) => Divider(),
                        //children: data!.reversed.map(requestView).toList(),
                      );
              }),
        ]),
      ),
      length: 2,
    );
  }

  Widget requestView(CircleRequestModal e) {
    var profile = e.circle.profile;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: (profile != null
            ? NetworkImage(profile)
            : AssetImage(
                'assets/default/business.jpg',
              )) as ImageProvider,
      ),
      title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${e.circle.name}'.toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${e.contact.name} (${e.contact.category})',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
      subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                '${e.contact.phone}',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                '${e.contact.type}',
                style: TextStyle(fontSize: 15),
              )
            ]),
            Row(children: [
              Expanded(
                child: Text(
                  '${e.contact.getFormatDate()}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () {
                  db
                      .members(e.reference)
                      .doc(e.contact.phoneNumber)
                      .set(e.contact);

                  db.sendNotifications(
                    contact: e.contact,
                    snapshot: e.snapshot,
                  );

                  var _circle = e.circle;
                  _circle.members.add(e.contact.phoneNumber ?? '');
                  _circle.request.remove(e.contact.referenceId ?? '');
                  e.reference.update({
                    'request': _circle.request,
                    'members': _circle.members,
                  });

                  db.request(e.reference).doc(e.contact.phoneNumber).delete();
                  setState(() => print('added'));
                },
                child: Text('Accept'),
              ),
              TextButton(
                onPressed: () {
                  db.request(e.reference).doc(e.contact.phoneNumber).delete();
                  setState(() => print('deleted'));
                },
                child: Text('Reject'),
              ),
            ]),
          ]),
    );
  }

  Widget loadNotifications(Notifications notification) {
    String profile = '';
    String name = '';

    return FutureBuilder(
      future: db.profile.doc(notification.senderId).get(),
      builder: (_, AsyncSnapshot<DocumentSnapshot<ProfileModal>> snapshot) {
        Widget leading = Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(),
        );

        if (snapshot.hasData) {
          try {
            name = snapshot.data!.get('name');
            profile = snapshot.data!.get('profile');

            leading = CircleAvatar(
              backgroundImage: (profile.isNotEmpty
                  ? NetworkImage(profile)
                  : AssetImage(
                      'assets/default/user.jpg',
                    )) as ImageProvider,
            );
          } catch (e) {
            print(e);
          }
        }

        return Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: leading,
            title: Text(notification.title),
            subtitle: Text('${name.toUpperCase()} ${notification.message}'),
          ),
          Container(
            padding: const EdgeInsets.only(right: 36),
            alignment: Alignment.centerRight,
            width: double.infinity,
            child: Text(
              notification.getFormatDate(),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 54, right: 36),
            child: Divider(thickness: 1),
          ),
        ]);
      },
    );
  }

  Future<List<CircleRequestModal>> getRequestList() async {
    var circles = await db.circle
        .where('type', isEqualTo: 'Social')
        .where('createdBy', isEqualTo: _profile.id)
        .get();

    List<CircleRequestModal> request = [];
    await Future.forEach(circles.docs,
        (QueryDocumentSnapshot<CircleModal> circle) async {
      var requests = await db.request(circle.reference).get();

      await Future.forEach(requests.docs,
          (QueryDocumentSnapshot<ContactModal> member) async {
        var requestModal = CircleRequestModal(
          contact: member.data(),
          circle: circle.data(),
          snapshot: circle,
        );

        request.add(requestModal);
      });
    });

    print('requests ${request.length}');
    return request;
  }
}
