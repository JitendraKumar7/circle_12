part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.obscureText = false,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;

  final bool obscureText;

  @override
  List<Object> get props =>
      [email, password, confirmedPassword, obscureText, status];

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    FormzStatus? status,
    bool? obscureText,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}
