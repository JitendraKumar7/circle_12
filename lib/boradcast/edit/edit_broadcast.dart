import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditBroadcast extends StatefulWidget {
  @override
  State<EditBroadcast> createState() => _EditBroadcastState();
}

class _EditBroadcastState extends State<EditBroadcast> {
  late QueryDocumentSnapshot<BroadcastModal> snapshot;
  late BroadcastModal modal;

  @override
  void initState() {
    super.initState();

    var args = ModalRoute.of(context)?.settings.arguments;
    snapshot = args as QueryDocumentSnapshot<BroadcastModal>;
    modal = snapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();

    return Scaffold(
      appBar: AppBar(title: Text('Edit Broadcast')),
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

            await snapshot.reference.set(modal);

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
