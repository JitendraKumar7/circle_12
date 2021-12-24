import 'package:circle/modal/modal.dart';
import 'package:circle/profile/verify/verify.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_button/timer_button.dart';

class VerifyForm extends StatelessWidget {
  final ProfileModal _modal;

  const VerifyForm(this._modal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCubit, VerifyState>(
      listener: (context, state) async {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Submit data Failure')),
            );
        }

        if (state.status.isSubmissionSuccess) {
         Navigator.pop(context,true);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Icon(
                  Icons.phone_android,
                  size: 120,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Phone Number Verification',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: 'Enter the code sent to ',
                    children: [
                      TextSpan(
                        text: _modal.phone,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                    style: TextStyle(color: Colors.black54, fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            _CodeInput(),
            SizedBox(height: 12),
            TimerButton(
              label: 'RESEND OTP',
              timeOutInSeconds: 30,
              onPressed: () {
                var cubit = context.read<VerifyCubit>();
                cubit.resend(_modal);
              },
              color: Colors.orange,
              disabledColor: Colors.grey.shade100,
              disabledTextStyle: TextStyle(fontSize: 18),
              activeTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 24),
            _SubmitButton(_modal),
          ]),
        ),
      ),
    );
  }
}

class _CodeInput extends StatelessWidget {
  const _CodeInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCubit, VerifyState>(
      buildWhen: (previous, current) => previous.code != current.code,
      builder: (context, state) {
        var cubit = context.read<VerifyCubit>();
        return Padding(
          padding: EdgeInsets.only(left: 72, right: 72),
          child: PinCodeTextField(
            blinkWhenObscuring: true,
            onChanged: (code) => cubit.codeChanged(code),
            keyboardType: TextInputType.phone,
            appContext: context,
            length: 4,
            obscureText: true,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              borderRadius: BorderRadius.circular(6),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final ProfileModal _modal;

  const _SubmitButton(
    this._modal, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCubit, VerifyState>(
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
                    ? () {
                        var cubit = context.read<VerifyCubit>();
                        cubit.saveProfile(_modal);
                      }
                    : null,
                child: const Text('SUBMIT'),
              );
      },
    );
  }
}
