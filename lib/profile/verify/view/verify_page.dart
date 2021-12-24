import 'package:circle/modal/modal.dart';
import 'package:circle/profile/verify/verify.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    final ProfileModal _modal = args as ProfileModal;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: BlocProvider(
          create: (_) => VerifyCubit(_modal),
          child: VerifyForm(_modal),
        ),
      ),
    );
  }
}
