import 'package:formz/formz.dart';

/// Validation errors for the [ConfirmedPasswordCode] [FormzInput].
enum ConfirmedPasswordCodeValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template confirmed_password}
/// Form input for a confirmed password input.
/// {@end template}
class ConfirmedPasswordCode
    extends FormzInput<String, ConfirmedPasswordCodeValidationError> {
  /// {@macro confirmed_password}
  const ConfirmedPasswordCode.pure({this.password = ''}) : super.pure('');

  /// {@macro confirmed_password}
  const ConfirmedPasswordCode.dirty({required this.password, String value = ''})
      : super.dirty(value);

  /// The original password.
  final String password;

  @override
  ConfirmedPasswordCodeValidationError? validator(String? value) {
    return password == value ? null : ConfirmedPasswordCodeValidationError.invalid;
  }
}
