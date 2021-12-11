part of '../index.dart';

class BottomBar extends StatelessWidget {
  final HomeState state;

  BottomBar(
    this.state, {
    Key? key,
  }) : super(key: key);

  Widget getIcon(int count, icon) {
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
    var currentIndex = bottomBarItem.indexWhere(state.isEqual);
    var modal = context.watch<ProfileModal>();
    return BottomNavigationBar(
      currentIndex: currentIndex > 0 ? currentIndex : 0,
      selectedItemColor: Color(0xFF3B5998),
      unselectedItemColor: Colors.grey[350],
      items: bottomBarItem.map((e) => _item(modal, e)).toList(),
      onTap: (position) {
        var item = bottomBarItem[position].item;
        BlocProvider.of<HomeBloc>(context).add(NavigateTo(item));
      },
    );
  }

  BottomNavigationBarItem _item(ProfileModal modal, NavigationItem item) {
    var count = item.title == 'Offers' ? modal.offerCounter : 0;
    return BottomNavigationBarItem(
      label: item.title,
      icon: getIcon(count, item.icon),
      backgroundColor: Colors.blue[300],
    );
  }
}
