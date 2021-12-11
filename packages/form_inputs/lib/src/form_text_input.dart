import 'package:formz/formz.dart';

/// Validation errors for the [FormTextInput] [FormzInput].
enum FormTextInputValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template FormTextInput}
class FormTextInput extends FormzInput<String, FormTextInputValidationError> {
  const FormTextInput.pure({this.empty = false}) : super.pure('');

  /// {@macro FormTextInput}
  const FormTextInput.dirty({this.empty = false, String value = ''})
      : super.dirty(value);

  /// empty
  final bool empty;

  @override
  FormTextInputValidationError? validator(String? value) {
    return empty
        ? null
        : value?.isNotEmpty == true
            ? null
            : FormTextInputValidationError.invalid;
  }
}
