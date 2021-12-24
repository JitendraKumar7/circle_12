import 'package:circle/business/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeywordsPage extends StatefulWidget {
  @override
  State<KeywordsPage> createState() => _KeywordsState();
}

class _KeywordsState extends State<KeywordsPage> {
  List<String> keywords = [];
  String editTextForm = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      keywords = args as List<String>;
      setState(() => print('keywords'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Keywords'.toUpperCase())),
      body: Column(children: [
        if (3 > keywords.length) ...[
          EditTextForm(
            'Keywords',
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
                    keywords.add(editTextForm.toUpperCase());
                    editTextForm = '';
                  });
              },
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
                primary: Colors.orange
              ),
              child: Icon(Icons.add),
            ),
          ),
        ],
        Expanded(
            child: ListView(
          children: keywords
              .map((e) => Column(children: [
                    ListTile(
                      title: Text('$e'),
                      leading: Icon(
                        Icons.security,
                        color: Colors.green,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => setState(() => keywords.remove(e)),
                      ),
                    ),
                    Divider(),
                  ]))
              .toList(),
        )),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              if (editTextForm.isNotEmpty) {
                keywords.add(editTextForm);
                editTextForm = '';
              }
              Navigator.pop(context, keywords);
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
