import 'package:carousel_slider/carousel_slider.dart';
import 'package:circle/app/app.dart';
import 'package:circle/constant/constant.dart';
import 'package:circle/google_mobile_ads/ads.dart';
import 'package:circle/home/bloc/home_bloc.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> with BannerAdState {
  final db = FirestoreService();
  late ProfileModal _profile;

  @override
  Widget build(BuildContext context) {
    _profile = context.read<ProfileModal>();
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.card_giftcard,
                color: Colors.white,
              ),
              child: Text(
                'BUSINESS',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.business,
                color: Colors.white,
              ),
              child: Text(
                'SOCIAL',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.family_restroom,
                color: Colors.white,
              ),
              child: Text(
                'FAMILY',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          getCircles('Business'),
          getCircles('Social'),
          getCircles('Family'),
        ]),
        floatingActionButton: FloatingActionButton(
          child: PopupMenuButton<String>(
            //icon: Icon(Icons.add),
            offset: Offset(-20.0, -99.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            itemBuilder: (_) => [
              PopupMenuItem<String>(
                value: 'AddContact',
                child: Row(children: [
                  Icon(Icons.contact_page, color: Colors.orange),
                  SizedBox(width: 18),
                  Text('Add Contact'),
                ]),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'AddCircle',
                child: Row(children: [
                  Icon(Icons.add_circle, color: Colors.orange),
                  SizedBox(width: 18),
                  Text('Add Circle'),
                ]),
              ),
            ],
            onSelected: (String value) async {
              if (_profile.businessProfile.isEmpty) {
                BlocProvider.of<HomeBloc>(context)
                    .add(NavigateTo(HomeItem.PROFILE));
                return;
              }
              switch (value) {
                case 'AddContact':
                  var _result =
                      await Navigator.pushNamed(context, CHOOSE_CIRCLE);
                  if (_result != null)
                    setState(() {
                      print('$CHOOSE_CIRCLE Successfully!');
                    });
                  break;
                case 'AddCircle':
                  var _result = await Navigator.pushNamed(context, ADD_CIRCLE);
                  if (_result != null)
                    setState(() {
                      print('$ADD_CIRCLE Successfully!');
                    });
                  break;
                default:
                  print(value);
                  break;
              }
            },
          ),
          onPressed: null,
        ),
      ),
      length: 3,
    );
  }

  Widget getCircles(String type) {
    return StreamWidgetBuilder(
      stream: db.circle
          .where('type', isEqualTo: type)
          .where('members', arrayContains: _profile.phoneNumber)
          .snapshots(),
      builder: (QuerySnapshot<CircleModal>? snapshot) {
        var data = snapshot?.docs ?? [];
        return data.isEmpty
            ? SliderBuilder()
            : StatefulBuilder(builder: (_, setState) {
                return ListView(children: [
                  //getAdWidget(),
                  ...data
                      .map((item) =>
                          CircleView(item, _profile, (bool isAdmin) {}))
                      .toList(),
                  getBanner(),
                ]);
              });
      },
    );
  }
}

class SliderBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CarouselSlider(
      items: ['1', '2', '3']
          .map((e) => Image.asset(
                'assets/home/$e.jpg',
                width: size.width,
                height: size.height,
              ))
          .toList(),
      options: CarouselOptions(
        height: size.height,
        viewportFraction: 0.8,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
    );
  }
}

class CircleView extends StatelessWidget {
  final QueryDocumentSnapshot<CircleModal> snapshot;
  final Function(bool isAdmin) delete;
  final ProfileModal profile;

  CircleView(
    this.snapshot,
    this.profile,
    this.delete, {
    Key? key,
  }) : super(key: key);

  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var circle = snapshot.data();

    var isAdmin = profile.id == circle.createdBy;

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        VIEW_CIRCLE,
        arguments: snapshot,
      ),
      onLongPress: () => delete(isAdmin),
      onDoubleTap: () => delete(isAdmin),
      child: Card(
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
              image: (circle.profile == null
                  ? AssetImage('assets/default/circle.jpg')
                  : NetworkImage(circle.profile!)) as ImageProvider,
              fit: BoxFit.fill,
            ),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (isAdmin) ...[
              Avatar(
                photo: profile.profile,
                avatarSize: 24,
              ),
              Text(
                '${profile.name}'.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ],
            if (!isAdmin)
              FutureBuilder(
                  future: db.profile.doc(circle.createdBy).get(),
                  builder: (_,
                      AsyncSnapshot<DocumentSnapshot<ProfileModal>> snapshot) {
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
            _showName('${circle.name}', isAdmin, true),
            _showDescription('${circle.description}'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FutureBuilder(
                future: db.offers
                    .where('createdBy', whereIn: circle.references)
                    .get(),
                builder:
                    (_, AsyncSnapshot<QuerySnapshot<OfferModal>> snapshot) {
                  var offers = snapshot.data?.size ?? 0;
                  return _cardButton(
                    () {
                      if (offers > 0)
                        Navigator.pushNamed(
                          context,
                          LIST_OFFER,
                          arguments: snapshot.data,
                        );
                    },
                    size.width / 5,
                    Icons.local_offer,
                    '$offers Offers',
                  );
                },
              ),
              _cardButton(
                null,
                size.width / 5,
                Icons.group,
                '${circle.members.length}',
              ),
              // Share Circle
              _cardButton(
                () async {
                  await Share.share(
                    getCircleShare(circle.documentId, circle.name),
                    subject: 'CircleApp',
                  );
                },
                size.width / 5,
                Icons.share,
                'Share',
              ),
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.visibility,
                size: 18,
                color: Colors.white,
              ),
              SizedBox(width: 12),
              Text(
                '${circle.viewers.length}',
                softWrap: true,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _showDescription(String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
        ],
      );

  Widget _cardButton(
    GestureTapCallback? onTap,
    double? size,
    IconData? icon,
    String text,
  ) =>
      InkWell(
        onTap: onTap,
        child: Card(
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
        ),
      );

  Widget _showName(
    String name,
    bool isAdmin,
    bool isMember,
  ) =>
      Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 12, bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            isAdmin
                ? Colors.blue.shade100
                : isMember
                    ? Colors.orange.shade100
                    : Colors.green.shade100,
            isAdmin
                ? Colors.blue.shade700
                : isMember
                    ? Colors.orange.shade700
                    : Colors.green.shade700,
            isAdmin
                ? Colors.blue.shade400
                : isMember
                    ? Colors.orange.shade400
                    : Colors.green.shade400,
            isAdmin
                ? Colors.blue.shade200
                : isMember
                    ? Colors.orange.shade200
                    : Colors.green.shade200,
            isAdmin
                ? Colors.blue.shade100
                : isMember
                    ? Colors.orange.shade100
                    : Colors.green.shade100,
          ]),
        ),
        child: Stack(
          children: [
            Positioned.fill(
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
            ),
            Align(
              child: Builder(builder: (context) {
                return TextButton.icon(
                  onPressed: isAdmin
                      ? () async {
                          var _result = await Navigator.pushNamed(
                            context,
                            EDIT_CIRCLE,
                            arguments: snapshot.data(),
                          );
                          //if (_result != null) setState(() => print('load'));
                          //print('_result $_result');
                        }
                      : null,
                  icon: Icon(
                    Icons.edit,
                    size: 18,
                    color: isAdmin ? Colors.white : Colors.grey,
                  ),
                  label: Text(
                    'Edit',
                    softWrap: true,
                    style: TextStyle(
                      color: isAdmin ? Colors.white : Colors.grey,
                    ),
                  ),
                );
              }),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      );
}
