import 'package:bloc/bloc.dart';
import '../ui/home_navigate.dart';
export '../ui/home_navigate.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(HomeItem.HOME));

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is NavigateTo) {
      if (event.destination != state.selectedItem) {
        yield HomeState(event.destination);
      }
    }
  }
}
