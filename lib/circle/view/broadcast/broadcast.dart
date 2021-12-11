import 'package:circle/app/app.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BroadcastPage extends StatefulWidget {
  final QueryDocumentSnapshot<CircleModal> snapshot;

  static Route<String> page(snapshot) {
    return MaterialPageRoute(builder: (_) => BroadcastPage(snapshot));
  }

  BroadcastPage(
    this.snapshot, {
    Key? key,
  }) : super(key: key);

  @override
  State<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var circle = widget.snapshot.data();

    var profile = context.read<ProfileModal>();
    return Scaffold(
      appBar: AppBar(title: Text('BROADCAST')),
      body: StreamWidgetBuilder(
          stream: db.broadcast(widget.snapshot.reference).snapshots(),
          builder: (QuerySnapshot<BroadcastModal>? modal) {
            return modal!.docs.isEmpty
                ? Image.asset(
                    'assets/empty/search.jpg',
                    fit: BoxFit.fitWidth,
                    height: size.height,
                    width: size.width,
                  )
                : ListView(
                    padding: EdgeInsets.only(bottom: 48),
                    children: modal.docs.reversed
                        .map((e) =>
                            ItemView(e, profile: profile, createdBy: circle.createdBy))
                        .toList(),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var _result = await Navigator.pushNamed(
            context,
            ADD_BROADCAST,
            arguments: widget.snapshot,
          );
          if (_result != null) setState(() => print('BROADCAST'));
        },
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final QueryDocumentSnapshot<BroadcastModal> snapshot;
  final ProfileModal profile;
  final String? createdBy;

  ItemView(
    this.snapshot, {
    Key? key,
    required this.profile,
    required this.createdBy,
  }) : super(key: key);

  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var item = snapshot.data();
    var text = Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 18, right: 18),
      child: Text('${item.description}'),
    );

    var isAdmin = profile.id == createdBy;
    var photo = item.photo;

    return Column(mainAxisSize: MainAxisSize.min, children: [
      isAdmin
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
                '${item.name}'.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${profile.getOrganizationName}'),
                    Text('${item.getFormatDate()}'),
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
          : FutureBuilder(
              future: db.profile.doc(createdBy).get(),
              builder:
                  (_, AsyncSnapshot<DocumentSnapshot<ProfileModal>> snapshot) {
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
                    '${item.name}'.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${profile?.getOrganizationName}'),
                        Text('${item.getFormatDate()}'),
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
              }),
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
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(48, 72, 48, 162),
              child: text,
            )
          : Image.network(photo),
      if (photo != null) text,
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        //Text(item.getFormatDate()),
        if (isAdmin) ...[
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              EDIT_BROADCAST,
              arguments: snapshot,
            ),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => snapshot.reference.delete(),
            icon: Icon(Icons.delete),
          ),
        ]
      ]),
      Divider(thickness: 5),
    ]);
  }
}
