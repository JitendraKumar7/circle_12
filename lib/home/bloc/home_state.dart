part of 'home_bloc.dart';

class HomeState {
  final HomeItem selectedItem;

  const HomeState(this.selectedItem);

  double get elevation => HomeItem.HOME == selectedItem ? 0 : 4;

  bool isEqual(NavigationItem item) => item.item == selectedItem;

  @override
  String toString() => 'Home State => $selectedItem';
}
