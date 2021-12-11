import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ForgottenPassword extends StatelessWidget {
  static Route<String> page() {
    return MaterialPageRoute(builder: (_) => ForgottenPassword());
  }

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var rep = context.read<AuthenticationRepository>();
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password'.toUpperCase())),
      body: Align(
        alignment: const Alignment(0, -1 / 1.8),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              'assets/app_logo.png',
              height: 120,
            ),
            const SizedBox(height: 48),
            Container(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Email Id',
                  filled: true,
                  fillColor: Colors.blue[50],
                ),
              ),
              padding: EdgeInsets.all(12),
            ),
            ElevatedButton(
              onPressed: () async {
                var email = controller.text;
                if (email.isNotEmpty) {
                  await rep.resetPassword(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: Text('Link sent on your email.'),
                      ),
                    ),
                  );
                }
              },
              child: Text('Reset'.toUpperCase()),
            ),
          ]),
        ),
      ),
    );
  }
}
