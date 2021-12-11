import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndexCubit extends Cubit<Widget> {
  IndexCubit() : super(Container());

  void index() => emit(Container());

  void profile() => emit(Container());
}
