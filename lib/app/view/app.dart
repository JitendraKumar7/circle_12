import 'package:authentication_repository/authentication_repository.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circle/home/index.dart';
import 'package:circle/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/app/app.dart';
import 'package:circle/theme.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository repository,
  })  : _authenticationRepository = repository,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) =>
            AppBloc(authenticationRepository: _authenticationRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.select((AppBloc bloc) => bloc.state.status);
    return MaterialApp(
      theme: theme,
      home: DoubleBack(
        child: state == AppStatus.authenticated ? IndexPage() : LoginPage(),
      ),
      onGenerateRoute: onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
