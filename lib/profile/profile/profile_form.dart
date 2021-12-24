import 'package:circle/app/app.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/profile/profile.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:formz/formz.dart';
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Phone Number Already Exist')),
            );
        }
        if (state.status.isSubmissionSuccess) {
          var _modal = ProfileModal();
          _modal.phoneNumber = state.phone.value;
          _modal.countryCode = state.code.value;
          _modal.email = state.email.value;
          _modal.name = state.name.value;
          _modal.profile = user.photo;
          _modal.id = user.id;
          var result = await Navigator.pushNamed(
            context,
            VERIFICATION,
            arguments: _modal,
          );
          if (result != null) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(photo: user.photo),
              SizedBox(height: 48),
              _NameInput(user),
              SizedBox(height: 9),
              _EmailInput(user),
              SizedBox(height: 9),
              _PhoneInput(user),
              SizedBox(height: 18),
              TextButton(
                onPressed: () async {
                  BlocProvider.of<AppBloc>(context).add(AppLogoutRequested());
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text('Change Account'),
              ),
              SizedBox(height: 24),
              _SubmitButton(),
              SizedBox(height: 9),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  final user;

  const _NameInput(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ProfileCubit>();
    if (user.name != null) {
      cubit.nameChanged(user.name);
    }
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          onChanged: (name) => cubit.nameChanged(name),
          keyboardType: TextInputType.name,
          initialValue: user.name,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            errorText: state.name.invalid ? 'invalid name' : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  final user;

  const _EmailInput(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ProfileCubit>();
    if (user.email != null) {
      cubit.emailChanged(user.email);
    }
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          readOnly: true,
          onChanged: (email) => cubit.emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          initialValue: user.email,
          decoration: InputDecoration(
            labelText: 'Email id',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            errorText: state.email.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PhoneInput extends StatelessWidget {
  final user;

  const _PhoneInput(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        var cubit = context.read<ProfileCubit>();
        return TextFormField(
          onChanged: (phone) => cubit.phoneChanged(phone),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            errorText: state.phone.invalid ? 'invalid Phone Number' : null,
            prefixIcon: CountryCodePicker(
              onChanged: (code) => cubit.countryChanged(code.dialCode),
              onInit: (code) => cubit.countryChanged(code!.dialCode),
              initialSelection: 'IN',
              showFlag: false,
              showFlagDialog: true,
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
                onPressed: state.status.isValidated
                    ? () async {
                        var cubit = context.read<ProfileCubit>();
                        cubit.saveProfile();
                      }
                    : null,
                child: const Text('SUBMIT'),
              );
      },
    );
  }
}
