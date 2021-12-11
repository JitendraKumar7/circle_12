import 'package:formz/formz.dart';

/// Validation errors for the [CountryCode] [FormzInput].
enum CountryCodeValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template CountryCode}
/// Form input for an CountryCode input.
/// {@end template}
class CountryCode extends FormzInput<String, CountryCodeValidationError> {
  /// {@macro CountryCode}
  const CountryCode.pure() : super.pure('');

  /// {@macro CountryCode}
  const CountryCode.dirty([String value = '']) : super.dirty(value);

  @override
  CountryCodeValidationError? validator(String? value) {
    return value != null ? null : CountryCodeValidationError.invalid;
  }
}
