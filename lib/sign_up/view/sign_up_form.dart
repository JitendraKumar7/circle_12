import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:circle/sign_up/sign_up.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
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
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _ConfirmPasswordInput(),
              const SizedBox(height: 8),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Id',
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) {
        bool obscureText = previous.obscureText != current.obscureText;
        bool password = previous.password != current.password;
        return password || obscureText;
      },
      builder: (context, state) {
        var cubit = context.read<SignUpCubit>();
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

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) {
        bool confirmedPassword =
            previous.confirmedPassword != current.confirmedPassword;
        bool obscureText = previous.obscureText != current.obscureText;
        bool password = previous.password != current.password;
        return password || obscureText || confirmedPassword;
      },
      builder: (context, state) {
        var cubit = context.read<SignUpCubit>();
        return TextField(
          onChanged: (confirmPassword) =>
              cubit.confirmedPasswordChanged(confirmPassword),
          obscureText: state.obscureText,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            errorText: state.confirmedPassword.invalid
                ? 'passwords do not match'
                : null,
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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onSurface: Colors.black,
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 24)),
                onPressed: state.status.isValidated
                    ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                    : null,
                child: const Text('SIGN UP'),
              );
      },
    );
  }
}
