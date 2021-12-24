import 'package:circle/app/app.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePage> {
  ProfileModal _modal = ProfileModal();

  @override
  Widget build(BuildContext context) {
    _modal = context.read<ProfileModal>();
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(12), children: [
        ImagePickerWidget(
          radius: 90,
          name: _modal.id,
          photo: _modal.profile,
          upload: Upload.PROFILE,
          assets: 'assets/default/user.jpg',
          updated: (String? path) => setState(() {
            _modal.profile = path;
            print('profile done ${_modal.profile}');
          }),
        ),
        EditTextForm(
          'Name',
          _modal.name,
          keyboardType: TextInputType.name,
          onChanged: (value) => _modal.name = value,
          readOnly: false,
          top: 18,
        ),
        EditTextForm(
          'Email',
          _modal.email,
          keyboardType: TextInputType.emailAddress,
          readOnly: true,
          top: 18,
        ),
        EditTextForm(
          'Phone No.',
          _modal.phone,
          keyboardType: TextInputType.phone,
          readOnly: true,
          top: 18,
        ),
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(left: 48, right: 48),
          child: ElevatedButton(
            onPressed: () async {
              var db = FirestoreService();
              var json = Map<String, dynamic>();
              json['profile'] = _modal.profile;
              json['name'] = _modal.name;

              _modal.listeners();
              await db.profile.doc(_modal.id).update(json);
              Navigator.of(context, rootNavigator: true).pop();
            },
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18),
              padding: EdgeInsets.all(12),
              maximumSize: Size(180, 45),
              primary: Colors.blue[300],
            ),
            child: Text('UPDATE'),
          ),
        ),
      ]),
    );
  }
}
