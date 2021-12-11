part of '../index.dart';

class DrawerWidget extends StatelessWidget {
  final Future<String> info;
  final HomeState state;

  DrawerWidget(
    this.state, {
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var modal = context.watch<ProfileModal>();
    return Drawer(
      child: ListView(children: [
        InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushNamed(context, EDIT_PROFILE);
          },
          child: Container(
            padding: EdgeInsets.all(12),
            color: Colors.blue[300],
            child: Row(children: [
              Avatar(
                photo: modal.profile,
                avatarSize: 30,
              ),
              SizedBox(width: 9),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  modal.name ?? 'Name',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  modal.email ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              ]),
            ]),
          ),
        ),
        ...drawerItem.map(_showItem).toList(),
        Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.centerRight,
          child: FutureBuilder(
              future: info,
              builder: (context, data) {
                return Text('${data.data ?? ''}');
              }),
        ),
      ]),
    );
  }

  _showItem(NavigationItem item) => Builder(
    builder: (context) => Card(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
            borderOnForeground: true,
            margin: EdgeInsets.zero,
            elevation: 0,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: state.isEqual(item) ? Colors.green : Colors.blueGrey,
                  ),
                ),
                leading: Icon(
                  item.icon,
                  color: state.isEqual(item) ? Colors.green : Colors.blueGrey,
                ),
                onTap: () async {
                  switch (item.item) {
                    case HomeItem.SHARE_APP:
                      await Share.share(
                        SHARE_APP_MESSAGE,
                        subject: 'CircleApp',
                      );
                      break;
                    case HomeItem.SUPPORT:
                      launch(SUPPORT_MAIL);
                      break;
                    case HomeItem.RATE_REVIEW:
                      launch(Platform.isAndroid ? ANDROID_URL : APPLE_URL);
                      break;
                    case HomeItem.LOGOUT:
                      BlocProvider.of<AppBloc>(context).add(AppLogoutRequested());
                      break;
                    default:
                      BlocProvider.of<HomeBloc>(context).add(NavigateTo(item.item));
                      Navigator.of(context, rootNavigator: true).pop();
                  }
                },
              ),
              Divider(height: 1),
            ]),
          )
  );
}
