import 'package:formz/formz.dart';

/// Validation errors for the [Name] [FormzInput].
enum NameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template Name}
/// Form input for an Name input.
/// {@end template}
class Name extends FormzInput<String, NameValidationError> {
  /// {@macro Name}
  const Name.pure() : super.pure('');

  /// {@macro Name}
  const Name.dirty([String value = '']) : super.dirty(value);

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z\s\.]*$',
  );

  @override
  NameValidationError? validator(String? value) {
    return _nameRegExp.hasMatch(value ?? '')
        ? null
        : NameValidationError.invalid;
  }
}
