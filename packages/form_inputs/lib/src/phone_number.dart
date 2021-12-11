import 'package:formz/formz.dart';

/// Validation errors for the [PhoneNumber] [FormzInput].
enum PhoneValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template PhoneNumber}
/// Form input for an PhoneNumber input.
/// {@endtemplate}
class PhoneNumber extends FormzInput<String, PhoneValidationError> {
  /// {@macro PhoneNumber}
  const PhoneNumber.pure() : super.pure('');

  /// {@macro PhoneNumber}
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  static final RegExp _phoneRegExp = RegExp(
    r'^(\+91[\-\s]?)?[0]?(91)?[789]\d{9}$',
  );

  @override
  PhoneValidationError? validator(String? value) {
    return _phoneRegExp.hasMatch(value ?? '')
        ? null
        : PhoneValidationError.invalid;
  }
}
