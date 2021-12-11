import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

_showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class EditCirclePage extends StatefulWidget {
  @override
  State<EditCirclePage> createState() => _EditCircleState();
}

class _EditCircleState extends State<EditCirclePage> {
  var _modal = CircleModal();


  Widget checkboxListTile() {
    var shape = RoundedRectangleBorder(
      side: BorderSide(),
      borderRadius: BorderRadius.circular(9),
    );
    return Container(
      //padding: EdgeInsets.all(18),
      margin: EdgeInsets.only(top: 9, bottom: 24),
      decoration: BoxDecoration(
        //color: Colors.red,
        // border: Border.all(),
        //borderRadius: BorderRadius.circular(9),
      ),
      child: Column(children: [
        Text(
          'Circle Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        if (_modal.isBusiness)
          CheckboxListTile(
            shape: shape,
            title: Text('Allow list member to add new member '),
            value: _modal.isAddMember,
            selected:  _modal.isAddMember,
            onChanged: (newValue) => setState(() {
              _modal.isAddMember = newValue as bool;
            }),
          ),
        if (_modal.isSocial) ...[
          SizedBox(height: 12),
          CheckboxListTile(
            shape: shape,
            title: Text('Allow to add vendors'),
            value: _modal.isAllowVendor,
            selected: _modal.isAllowVendor,
            onChanged: (newValue) => setState(() {
              _modal.isAllowVendor = newValue as bool;
            }),
          ),
          SizedBox(height: 12),
          CheckboxListTile(
            shape: shape,
            title: Text('Allow to add emergencies'),
            value: _modal.isAllowEmergencies,
            selected:  _modal.isAllowEmergencies,
            onChanged: (newValue) => setState(() {
              _modal.isAllowEmergencies = newValue as bool;
            }),
          ),
          SizedBox(height: 12),
          CheckboxListTile(
            shape: shape,
            title: Text('Allow to add gate pass'),
            value: _modal.isAllowGatePass,
            selected:  _modal.isAllowGatePass,
            onChanged: (newValue) => setState(() {
              _modal.isAllowGatePass = newValue as bool;
            }),
          ),
          SizedBox(height: 12),
          CheckboxListTile(
            shape: shape,
            title: Text('House No. Required or Not!'),
            value: _modal.isHouseNo,
            selected:  _modal.isHouseNo,
            onChanged: (newValue) => setState(() {
              _modal.isHouseNo = newValue as bool;
            }),
          ),
          SizedBox(height: 12),
          CheckboxListTile(
            shape: shape,
            title: Text('Admin approval is required to add new member'),
            value: _modal.isAdminApproval,
            selected:  _modal.isAdminApproval,
            onChanged: (newValue) => setState(() {
              _modal.isAdminApproval = newValue as bool;
            }),
          ),
        ],
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    _modal = args as CircleModal;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Circle'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        ImagePickerWidget(
          photo:_modal.profile,
          upload: Upload.CIRCLE,
          name:_modal.documentId,
          assets: 'assets/default/circle.jpg',
          updated: (String? path) => setState(() {
            _modal.profile = path;
            print('CIRCLE done ${_modal.profile}');
          }),
        ),
        SizedBox(height: 18),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Circle Name',
            helperText: '',
          ),
          keyboardType: TextInputType.name,
          onChanged: (String value) => _modal.name = value,
          controller: TextEditingController(text: _modal.name),
        ),
        TextFormField(
          minLines: 9,
          maxLines: 12,
          decoration: InputDecoration(
            labelText: 'Circle Description',
            helperText: '',
          ),
          keyboardType: TextInputType.multiline,
          onChanged: (String value) => _modal.description = value,
          controller: TextEditingController(text: _modal.description),
        ),
        _modal.isFamily ? SizedBox(height: 24) : checkboxListTile(),
        ElevatedButton(
          onPressed: () async {
            if (_modal.name?.isEmpty ?? true) {
              _showSnackBar(context, 'Name Can\'t be empty');
              return;
            }

            showCenterLoader(context);
            var db = FirestoreService();
            var _circle = db.circle.doc(_modal.documentId);
            await _circle.update(_modal.toJson());

            Navigator.of(context, rootNavigator: true).pop(true);
            print('=> $_modal');
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
