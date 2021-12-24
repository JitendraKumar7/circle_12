import 'dart:math';

import 'package:circle/app/api/api_client.dart' as api;
import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  VerifyCubit(ProfileModal _modal) : super(const VerifyState()) {
    password = '${Random().nextInt(9000) + 1000}';
    print('Random Generate $password');
    api.sentOtp(_modal, password);
  }

  String password = '0';

  void resend(_modal) {
    print('Random Generate $password');
    api.sentOtp(_modal, password);
  }

  void codeChanged(String value) {
    final code = ConfirmedPasswordCode.dirty(
      password: password,
      value: value,
    );
    emit(state.copyWith(
      code: code,
      status: Formz.validate([
        code,
      ]),
    ));
  }

  Future<void> saveProfile(ProfileModal _modal) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var db = FirestoreService();
      await firstConversion(_modal.id, _modal.name);
      await db.profile.doc(_modal.id).set(_modal).whenComplete(() {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      });
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
