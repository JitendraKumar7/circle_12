import 'package:circle/app/app.dart';
import 'package:circle/home/index.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/modal/modal.dart';

class ViewContactPage extends StatefulWidget {
  @override
  State<ViewContactPage> createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContactPage> {
  ContactModal _modal = ContactModal();
  var db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    _modal = args as ContactModal;
    return Scaffold(
      appBar: AppBar(title: Text('View Contact'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: '',
          ),
          controller: TextEditingController(text: _modal.name),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            helperText: '',
          ),
          controller: TextEditingController(text: _modal.phone),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Category',
            helperText: '',
          ),
          controller: TextEditingController(text: _modal.category),
        ),
        if (_modal.houseNo != null)
          TextFormField(
            decoration: InputDecoration(
              labelText: 'House No.',
              helperText: '',
            ),
            controller: TextEditingController(text: _modal.houseNo),
          ),
        Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              child: Text('This member is added in the circle by '),
              padding: EdgeInsets.all(12),
            ),
            FutureWidgetBuilder(
                future: db.profile.doc(_modal.reference).get(),
                builder: (DocumentSnapshot<ProfileModal>? data) {
                  var _profile = data!.data();
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => Navigator.pushNamed(
                      context,
                      VIEW_PROFILE,
                      arguments: _profile!.id,
                    ),
                    leading: Avatar(photo: _profile!.profile),
                    title: Text('${_profile.name}'.toUpperCase()),
                    subtitle: Text(
                      '${_modal.phone}',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }),
          ]),
        ),
      ]),
    );
  }
}
