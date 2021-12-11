import 'package:circle/app/app.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:circle/modal/modal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_contact_picker/easy_contact_picker.dart';

_showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class AddContactPage extends StatefulWidget {
  @override
  State<AddContactPage> createState() => _AddContactState();
}

class _AddContactState extends State<AddContactPage> {
  late QueryDocumentSnapshot<CircleModal> snapshot;
  ContactModal _modal = ContactModal();
  CircleModal _circle = CircleModal();

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

      await Permission.contacts.request();
      final _contactPicker = EasyContactPicker();

      Contact _contact = await _contactPicker.selectContactWithNative();

      String code = _modal.countryCode ?? '+91';
      var phoneNumber = _contact.phoneNumber?.replaceAll(code, '');

      _modal.name = _contact.fullName;
      _modal.phoneNumber = phoneNumber;
      setState(() => print('AddContactPage'));
    });
  }

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    _modal.reference = profile.id;
    return Scaffold(
      appBar: AppBar(title: Text('Add Contact')),
      body: ListView(padding: EdgeInsets.all(18), children: [
        TextFormField(
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Name',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
          ),
          onChanged: (value) => _modal.name = value,
          controller: TextEditingController(text: _modal.name),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            prefixIcon: CountryCodePicker(
              onChanged: (code) => _modal.countryCode = code.dialCode,
              onInit: (code) => _modal.countryCode = code!.dialCode,
              initialSelection: 'IN',
              showFlag: false,
              showFlagDialog: true,
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
            ),
          ),
          onChanged: (value) => _modal.phoneNumber = value,
          controller: TextEditingController(text: _modal.phoneNumber),
        ),
        CategoryForm(
          left: 0,
          right: 0,
          editable: true,
          selectedItem: _modal.category,
          onChanged: (value) => _modal.category = value,
        ),
        if (_circle.isHouseNo)
          TextFormField(
            decoration: InputDecoration(
              labelText: 'House No.',
              helperText: '',
              filled: true,
              fillColor: Colors.blue[50],
            ),
            onChanged: (value) => _modal.houseNo = value,
            controller: TextEditingController(text: _modal.houseNo),
          ),
        if (_circle.isSocial)
          for (int i = 0; i < _types.length; i++) ...[
            SizedBox(height: 18),
            ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(),
                borderRadius: BorderRadius.circular(9),
              ),
              onTap: () {
                setState(() => _modal.type = _types[i]);
              },
              leading: Icon(
                Icons.check_circle,
                color: _modal.type == _types[i] ? Colors.green : Colors.grey,
              ),
              selected: _modal.type == _types[i],
              title: Text('Add as a ${_types[i]}'.toUpperCase()),
            ),
          ],

        // submit and save button
        Padding(
          padding: const EdgeInsets.only(left: 80, right: 80, top: 24),
          child: ElevatedButton(
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

              var db = FirestoreService();

              bool _condition =
                  _circle.isAdminApproval && profile.id != _circle.createdBy;

              var reference = _condition
                  ? db.request(snapshot.reference)
                  : db.members(snapshot.reference);

              var request = _circle.request.any((e) => e == _modal.phoneNumber);
              var members = _circle.members.any((e) => e == _modal.phoneNumber);

              if (request || members) {
                _showSnackBar(context, 'Contact already exists!!');
              }
              // submitting
              else {
                showCenterLoader(context);
                _condition
                    ? _circle.request.add(profile.id ?? '')
                    : _circle.members.add(_modal.phoneNumber ?? '');

                await snapshot.reference.update({
                  'request': _circle.request,
                  'members': _circle.members,
                });
                await reference.doc(_modal.phoneNumber).set(_modal);
                //if (!_condition)
                await db.sendNotifications(
                  snapshot: snapshot,
                  contact: _modal,
                );
                Navigator.of(context, rootNavigator: true).pop(true);
              }
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
        ),
      ]),
    );
  }
}
