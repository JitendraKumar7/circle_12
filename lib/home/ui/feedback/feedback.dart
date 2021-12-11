import 'package:circle/app/app.dart';
import 'package:circle/home/bloc/home_bloc.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  final db = FirestoreService();
  final modal = FeedbackModal();

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            border: Border.all(
              color: Colors.blue,
              width: 1,
            ),
            color: Colors.white,
          ),
          child: TextFormField(
            maxLines: 10,
            minLines: 10,
            onChanged: (value) => modal.message = value,
            controller: TextEditingController(text: modal.message),
            decoration: InputDecoration(
              hintText: 'Write your Feedback...',
              fillColor: Colors.white,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                if (modal.message?.isNotEmpty ?? false) {
                  modal.reference = profile.id;
                  db.feedback.doc(modal.documentId).set(modal);
                  BlocProvider.of<HomeBloc>(context)
                      .add(NavigateTo(HomeItem.HOME));
                }
              },
            ),
          ),
        ),
      ]),
    );
  }
}

