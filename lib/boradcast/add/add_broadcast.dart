import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBroadcast extends StatefulWidget {
  @override
  State<AddBroadcast> createState() => _AddBroadcastState();
}

class _AddBroadcastState extends State<AddBroadcast> {
  BroadcastModal modal = BroadcastModal();
  var db = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    var args = ModalRoute.of(context)?.settings.arguments;
    var snapshot = args as QueryDocumentSnapshot<CircleModal>;

    print('${profile.name}');
    return Scaffold(
      appBar: AppBar(title: Text('Add Broadcast'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        ImagePickerWidget(
          photo: modal.photo,
          name: modal.documentId,
          upload: Upload.BROADCAST,
          assets: 'assets/default/offer.jpg',
          updated: (String? path) => setState(() {
            modal.photo = path;
            print('BROADCAST done ${modal.photo}');
          }),
        ),
        SizedBox(height: 18),
        TextFormField(
          decoration: InputDecoration(
            errorText: modal.errorName,
            labelText: 'Name',
            helperText: '',
          ),
          keyboardType: TextInputType.name,
          onChanged: (String value) => modal.name = value,
          controller: TextEditingController(text: modal.name),
        ),
        SizedBox(height: 6),
        TextFormField(
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            errorText: modal.errorDescription,
            labelText: 'Description',
            helperText: '',
          ),
          keyboardType: TextInputType.multiline,
          onChanged: (String value) => modal.description = value,
          controller: TextEditingController(text: modal.description),
        ),
        SizedBox(height: 18),
        ElevatedButton(
          onPressed: () async {
            if (modal.hasError) {
              setState(() => print('error => $modal'));
              return;
            }

            await db
                .broadcast(snapshot.reference)
                .doc(modal.documentId)
                .set(modal);

            Navigator.of(context, rootNavigator: true).pop(true);
            print('BROADCAST => $modal');
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              'SUBMIT',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ]),
    );
  }
}
