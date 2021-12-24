import 'package:circle/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  //context.read<AuthenticationRepository>()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'.toUpperCase()),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: BlocProvider(
          create: (_) => ProfileCubit(),
          child: const ProfileForm(),
        ),
      ),
    );
  }
}
