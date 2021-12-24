import 'package:circle/app/app.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:circle/modal/modal.dart';

_showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class ContactRequestPage extends StatefulWidget {
  @override
  State<ContactRequestPage> createState() => _ContactRequestState();
}

class _ContactRequestState extends State<ContactRequestPage> {
  late QueryDocumentSnapshot<CircleModal> snapshot;

  var _modal = ContactModal();
  var _circle = CircleModal();

  List<String> _labels = [
    'Add as a member',
    'Add as a vendors',
    'Add as a emergencies',
  ];

  List<String> _types = ['Members'];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var args = ModalRoute.of(context)?.settings.arguments;
      snapshot = args as QueryDocumentSnapshot<CircleModal>;
      _circle = snapshot.data();

      if (_circle.isAllowVendor) _types.add('Vendor');
      if (_circle.isAllowEmergencies) _types.add('Emergencies');

      var profile = context.read<ProfileModal>();
      _modal.countryCode = profile.countryCode;
      _modal.phoneNumber = profile.phoneNumber;

      _modal.category = profile.getBusinessCategory;
      _modal.referenceId = profile.id;
      _modal.name = profile.name;

      _modal.reference = _circle.createdBy;

      setState(() => print('value'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Request'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: '',
          ),
          enabled: false,
          readOnly: true,
          onChanged: (value) => _modal.name = value,
          controller: TextEditingController(text: _modal.name),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            helperText: '',
          ),
          enabled: false,
          readOnly: true,
          onChanged: (value) => _modal.phoneNumber = value,
          controller: TextEditingController(text: _modal.phoneNumber),
        ),
        CategoryForm(
          left: 0,
          right: 0,
          selectedItem: _modal.category,
          onChanged: (value) => _modal.category = value,
        ),
        if (_circle.isHouseNo)
          TextFormField(
            decoration: InputDecoration(
              labelText: 'House No.',
              helperText: '',
            ),
            onChanged: (value) => _modal.houseNo = value,
            controller: TextEditingController(text: _modal.houseNo),
          ),
        if (_circle.isSocial)
          for (int i = 0; i < _types.length; i++)
            ListTile(
              onTap: () {
                setState(() => _modal.type = _types[i]);
              },
              leading: Icon(
                Icons.check_circle,
                color: _modal.type == _types[i] ? Colors.green : Colors.grey,
              ),
              selected: _modal.type == _types[i],
              title: Text(_labels[i]),
            ),

        // submit and save button
        ElevatedButton(
          onPressed: () async {
            if (_modal.name?.isEmpty ?? true) {
              _showSnackBar(context, 'Name Can\'t be empty');
              return;
            }

            if (_modal.phoneNumber?.isEmpty ?? true) {
              _showSnackBar(context, 'Phone No. Can\'t be empty');
              return;
            }

            if (_modal.category?.isEmpty ?? true) {
              _showSnackBar(context, 'Category Can\'t be empty');
              return;
            }

            if ((_modal.houseNo?.isEmpty ?? true) && _circle.isHouseNo) {
              _showSnackBar(context, 'House No Can\'t be empty');
              return;
            }


            showCenterLoader(context);
            var db = FirestoreService();

            _circle.request.add(_modal.referenceId ?? '');
            var reference = db.request(snapshot.reference);
            await reference.doc(_modal.phoneNumber).set(_modal);
            await snapshot.reference.update({'request': _circle.request});

            Navigator.of(context, rootNavigator: true).pop(true);
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
