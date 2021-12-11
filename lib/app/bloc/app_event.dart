part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppStartedRequested extends AppEvent {}

class AppSliderRequested extends AppEvent {}

class AppLogoutRequested extends AppEvent {}

class AppUserChanged extends AppEvent {

  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
