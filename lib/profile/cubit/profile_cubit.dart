import 'package:circle/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      status: Formz.validate([
        name,
        state.email,
        state.code,
        state.phone,
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        state.name,
        email,
        state.code,
        state.phone,
      ]),
    ));
  }

  void phoneChanged(String value) {
    final phone = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([
        state.name,
        state.email,
        state.code,
        phone,
      ]),
    ));
  }

  void countryChanged(String? value) {
    print('countryChanged $value');
    final code = CountryCode.dirty(value ?? '');
    emit(state.copyWith(
      code: code,
      status: Formz.validate([
        state.name,
        state.email,
        code,
        state.phone,
      ]),
    ));
  }

  Future<void> saveProfile() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var phone = state.phone.value;
      var db = FirestoreService();
      var profile = await db.profile.get();
      var isExist = profile.docs.any((e) => e.get('phoneNumber') == phone);
      emit(state.copyWith(
          status: isExist
              ? FormzStatus.submissionFailure
              : FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
