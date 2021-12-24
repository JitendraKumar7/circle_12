import 'dart:io';

import 'package:share/share.dart';
import 'package:circle/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:force_update/force_update.dart';

import 'bloc/home_bloc.dart';

part 'widgets/avatar.dart';

part 'widgets/drawer.dart';

part 'widgets/bottom_bar.dart';

part 'widgets/body_switcher.dart';

class _View extends StatelessWidget {
  final Future<String> info;

  const _View(
    this.info, {
    Key? key,
  }) : super(key: key);

  Widget getIcon(int count) {
    var icon = Icons.notifications;
    return count == 0
        ? Icon(icon)
        : Stack(children: <Widget>[
            Icon(icon),
            Positioned(
              right: 0,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.red,
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]);
  }

  @override
  Widget build(BuildContext context) {
    var modal = context.watch<ProfileModal>();
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, HomeState state) {
          var item = navigationItem.firstWhere(state.isEqual);
          return Scaffold(
            appBar: AppBar(
                elevation: state.elevation,
                title: Text(item.getTitle),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, SEARCH),
                    icon: Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, NOTIFICATION),
                    icon: getIcon(modal.notificationCounter),
                  ),
                ]),
            body: BodySwitcher(state),
            drawer: DrawerWidget(state, info: info),
            bottomNavigationBar: BottomBar(state),
          );
        },
      ),
    );
  }
}

class IndexPage extends StatefulWidget {
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late CheckVersion checkVersion;
  var modal = ProfileModal();

  @override
  void initState() {
    super.initState();
    var id = context.read<AppBloc>().state.user.id;
    _loading(FirestoreService().profile.doc(id));

    checkVersion = CheckVersion(context);

    /*checkVersion.fromPlatform().then((packageInfo) {
      setState(() {
        String appName = packageInfo.appName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        print('appName $appName, version $version, buildNumber $buildNumber');
        _version = packageInfo.version;

        _getProfile();
      });
    });*/

    checkVersion.getVersionStatus().then((appStatus) {
      if (appStatus.canUpdate ?? false) checkVersion.showUpdateDialog();

      //print('canUpdate ${appStatus.canUpdate}');
      print('localVersion ${appStatus.localVersion}');
      //print('appStoreLink ${appStatus.appStoreUrl}');
      print('storeVersion ${appStatus.storeVersion}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return modal.id == null
        ? Scaffold(
            appBar: AppBar(title: Text('Loading...')),
            body: Center(child: CupertinoActivityIndicator()),
          )
        : _View(checkVersion.getVersion());
  }

  _loading(DocumentReference<ProfileModal> reference) async {
    var snapshot = await reference.get(GetOptions(source: Source.server));
    if (snapshot.exists && mounted) {
      var json = snapshot.data()?.toJson();

      modal = context.read<ProfileModal>();
      modal.fromJsonProvider(json);
      modal.listeners();

      print('offerCounter ${modal.offerCounter}');
      print('notificationCounter ${modal.notificationCounter}');

      setState(() => print('#Home ${snapshot.id}'));
    }
    // Verify Mobile
    else if (modal.id == null && mounted) {
      await Navigator.pushNamed(context, PROFILE);
      if (mounted) _loading(reference);
    }
  }
}
