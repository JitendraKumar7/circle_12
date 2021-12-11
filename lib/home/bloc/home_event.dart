part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class NavigateTo extends HomeEvent {
  final HomeItem destination;

  const NavigateTo(this.destination);

  @override
  String toString() => 'NavigateTo => $destination';
}