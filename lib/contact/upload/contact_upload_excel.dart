import 'package:circle/app/app.dart';
import 'package:circle/excel/excel_picker.dart';
import 'package:flutter/material.dart';
import 'package:circle/modal/modal.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadContactPage extends StatefulWidget {
  @override
  State<UploadContactPage> createState() => _UploadContactState();
}

class _UploadContactState extends State<UploadContactPage> {
  late QueryDocumentSnapshot<CircleModal> snapshot;

  List<ContactModal> _contacts = [];
  List<String> _types = ['Members'];
  var _circle = CircleModal();

  var _type = 'Members';

  bool upload = true;
  int progress = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var args = ModalRoute.of(context)?.settings.arguments;
      snapshot = args as QueryDocumentSnapshot<CircleModal>;

      _circle = snapshot.data();

      if (_circle.isAllowVendor) _types.add('Vendor');
      if (_circle.isAllowEmergencies) _types.add('Emergencies');

      print('AddContactPage');
      await Permission.storage.request();
      final _excelPicker = ExcelPicker();

      var data = await _excelPicker.excelToJson();

      data.forEach((element) {
        //{S.No.: 153, Name : Bala Ji Store, Mobile: 919971490316, Category : Accountant}
        ContactModal _modal = ContactModal();
        _modal.reference = _circle.createdBy;
        _modal.countryCode = '+${element['CountryCode'] ?? '91'}';
        _modal.phoneNumber = element['Mobile'];
        _modal.category = element['Category'];
        _modal.houseNo = element['Address'];
        _modal.name = element['Name'];
        _modal.type = _type;

        if (_modal.isNotEmpty) _contacts.add(_modal);

        print('element => ${element['Name']}');
        print('element => $_modal');
      });

      setState(() {
        print('AddContactPage ${_contacts.length}');
        upload = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var profile = context.read<ProfileModal>();
    return Scaffold(
      appBar: AppBar(title: Text('Upload Contact'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        ..._contacts
            .map((e) => ListTile(
                  title: Text(e.name ?? ''),
                  subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.phone),
                        Text(e.category ?? ''),
                      ]),
                ))
            .toList(),
        if (_circle.isSocial)
          for (int i = 0; i < _types.length; i++) ...[
            SizedBox(height: 18),
            ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(),
                borderRadius: BorderRadius.circular(9),
              ),
              onTap: () {
                setState(() => _type = _types[i]);
              },
              leading: Icon(
                Icons.check_circle,
                color: _type == _types[i] ? Colors.green : Colors.grey,
              ),
              selected: _type == _types[i],
              title: Text('Add as a ${_types[i]}'.toUpperCase()),
            ),
          ],

        // submit and save button
        StatefulBuilder(builder: (context, setState1) {
          print('Progress $progress, Upload => $upload');
          return Padding(
            padding: const EdgeInsets.only(left: 80, right: 80, top: 24),
            child: ElevatedButton(
              onPressed: upload
                  ? null
                  : () async {
                      var db = FirestoreService();

                      var reference = db.members(snapshot.reference);

                      _contacts.forEach((element) {
                        _circle.members.add(element.phoneNumber ?? '');
                      });

                      setState(() {
                        progress++;
                        upload = true;
                        print('progress $progress');
                      });
                      await snapshot.reference.update({
                        'request': _circle.request,
                        'members': _circle.members,
                      });

                      await Future.forEach(_contacts,
                          (ContactModal _modal) async {
                        await reference.doc(_modal.phoneNumber).set(_modal);
                        /*await db.sendNotifications(
                            snapshot: snapshot,
                            contact: _modal,
                          );*/
                        setState(() {
                          progress++;
                          upload = true;
                          print('progress $progress');
                        });
                      });

                      Navigator.of(context, rootNavigator: true).pop(true);
                    },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  upload ? '$progress / ${_contacts.length}' : 'SUBMIT',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          );
        }),
      ]),
    );
  }
}
