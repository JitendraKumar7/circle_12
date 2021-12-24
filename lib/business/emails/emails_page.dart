import 'package:circle/business/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailsPage extends StatefulWidget {
  @override
  State<EmailsPage> createState() => _EmailsState();
}

class _EmailsState extends State<EmailsPage> {
  List<String> businessEmails = [];
  String editTextForm = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessEmails = args as List<String>;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emails'.toUpperCase())),
      body: Column(children: [
        if (3 > businessEmails.length) ...[
          EditTextForm(
            'Email Address',
            editTextForm,
            keyboardType: TextInputType.emailAddress,
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
                    businessEmails.add(editTextForm);
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
          children: businessEmails
              .map((e) => ListTile(
                    leading: Icon(
                      Icons.mail,
                      color: Colors.green,
                    ),
                    title: Text('$e'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() => businessEmails.remove(e));
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
                businessEmails.add(editTextForm);
                editTextForm = '';
              }
              Navigator.pop(context, businessEmails);
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
