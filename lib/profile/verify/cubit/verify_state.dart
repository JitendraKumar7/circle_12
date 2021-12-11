part of 'verify_cubit.dart';

class VerifyState extends Equatable {
  const VerifyState({
    this.code = const ConfirmedPasswordCode.pure(),
    this.status = FormzStatus.pure,
  });

  final ConfirmedPasswordCode code;
  final FormzStatus status;

  @override
  List<Object> get props => [code, status];

  VerifyState copyWith({
    ConfirmedPasswordCode? code,
    FormzStatus? status,
  }) {
    return VerifyState(
      code: code ?? this.code,
      status: status ?? this.status,
    );
  }
}
