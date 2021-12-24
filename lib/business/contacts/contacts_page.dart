import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<ContactsPage> createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage> {
  List<BusinessContactModal> businessContacts = [];
  String editTextForm = '';
  String? countryCode = '+91';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessContacts = args as List<BusinessContactModal>;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts'.toUpperCase())),
      body: Column(children: [
        if (3 > businessContacts.length) ...[
          CountryCodePicker(
            onChanged: (code) => countryCode = code.dialCode,
            onInit: (code) => countryCode = code!.dialCode,
            initialSelection: 'IN',
            //showFlag: false,
            showFlagDialog: true,
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
          ),
          EditTextForm(
            'Phone Number',
            editTextForm,
            keyboardType: TextInputType.phone,
            onChanged: (value) => editTextForm = value,
            readOnly: false,
            top: 18,
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                if (editTextForm.isNotEmpty)
                  setState(() {
                    businessContacts.add(BusinessContactModal(
                      phoneNumber: editTextForm,
                      countryCode: countryCode,
                    ));
                    editTextForm = '';
                  });
              },
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder(),
                  primary: Colors.orange),
              child: Icon(Icons.add),
            ),
          ),
        ],
        Expanded(
            child: Column(
          children: businessContacts
              .map((e) => ListTile(
                    leading: Icon(Icons.call),
                    title: Text('${e.phone}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() => businessContacts.remove(e));
                      },
                    ),
                  ))
              .toList(),
        )),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              if (editTextForm.isNotEmpty) {
                businessContacts.add(BusinessContactModal(
                  phoneNumber: editTextForm,
                  countryCode: countryCode,
                ));
                editTextForm = '';
              }
              Navigator.pop(context, businessContacts);
            },
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18),
              padding: EdgeInsets.all(12),
                minimumSize: Size(180, 45),
                primary: Colors.blue[300]),
            child: Text('UPDATE'),
          ),
        )
      ]),
    );
  }
}
