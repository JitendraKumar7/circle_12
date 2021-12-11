part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.code = const CountryCode.pure(),
    this.phone = const PhoneNumber.pure(),
    this.status = FormzStatus.pure,
  });

  final Name name;
  final Email email;
  final CountryCode code;
  final PhoneNumber phone;
  final FormzStatus status;

  @override
  List<Object> get props => [name, email, code, phone, status];

  ProfileState copyWith({
    Name? name,
    Email? email,
    CountryCode? code,
    PhoneNumber? phone,
    FormzStatus? status,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      code: code ?? this.code,
      phone: phone ?? this.phone,
      status: status ?? this.status,
    );
  }
}
