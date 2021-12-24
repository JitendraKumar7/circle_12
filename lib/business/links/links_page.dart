import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinksPage extends StatefulWidget {
  @override
  State<LinksPage> createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  List<BusinessLinkModal> businessLinks = [];
  String editTextForm = '';
  String? linkType;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessLinks = args as List<BusinessLinkModal>;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Links'.toUpperCase())),
      body: Column(children: [
        Container(
          padding: EdgeInsets.only(
            right: 12,
            left: 12,
            top: 18,
          ),
          child: DropdownButtonFormField<String>(
            items: linkTypes
                .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            value: linkType,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Link Type',
              helperText: '',
            ),
            onChanged: (value) => linkType = value,
          ),
        ),
        EditTextForm(
          'URL',
          editTextForm,
          keyboardType: TextInputType.url,
          onChanged: (value) => editTextForm = value,
          readOnly: false,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 12),
          child: ElevatedButton(
            onPressed: () {
              if (editTextForm.isNotEmpty && linkType != null)
                setState(() {
                  businessLinks.add(BusinessLinkModal(
                    link: editTextForm,
                    type: linkType,
                  ));
                  editTextForm = '';
                  linkType = null;
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
        Expanded(
            child: ListView(
          children: businessLinks
              .map((e) => ListTile(
                    leading: e.icon,
                    title: Text('${e.link}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => setState(() => businessLinks.remove(e)),
                    ),
                  ))
              .toList(),
        )),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              if (editTextForm.isNotEmpty && linkType != null) {
                businessLinks.add(BusinessLinkModal(
                  link: editTextForm,
                  type: linkType,
                ));
                editTextForm = '';
              }
              Navigator.pop(context, businessLinks);
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
