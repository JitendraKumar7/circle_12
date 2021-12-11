part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.obscureText = false,
  });

  final Email email;
  final Password password;
  final FormzStatus status;

  final bool obscureText;

  @override
  List<Object> get props => [email, password, obscureText, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    bool? obscureText,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      obscureText: obscureText ?? this.obscureText,
    );
  }
}
