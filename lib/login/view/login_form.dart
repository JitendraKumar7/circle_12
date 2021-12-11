import 'package:circle/app/app.dart';
import 'package:circle/forgot/forgotten_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circle/login/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/app_logo.png',
                height: 120,
              ),
              const SizedBox(height: 48),
              _EmailInput(),
              const SizedBox(height: 9),
              _PasswordInput(),
              const SizedBox(height: 9),
              _ForgottenButton(),
              const SizedBox(height: 9),
              _LoginButton(),
              const SizedBox(height: 9),
              _GoogleLoginButton(),
              const SizedBox(height: 6),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email id',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        bool obscureText = previous.obscureText != current.obscureText;
        bool password = previous.password != current.password;
        return password || obscureText;
      },
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return TextField(
          onChanged: (password) => cubit.passwordChanged(password),
          obscureText: state.obscureText,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            errorText: state.password.invalid ? 'invalid password' : null,
            suffixIcon: IconButton(
              onPressed: () => cubit.obscureText(!state.obscureText),
              icon: Icon(
                state.obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  onSurface: Colors.black,
                  primary: Colors.orange,
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('LOGIN'),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, SIGN_UP),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ForgottenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {
        Navigator.push(context, ForgottenPassword.page());
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
