import 'package:circle/app/app.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/material.dart';

_showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class EditOfferPage extends StatefulWidget {
  @override
  State<EditOfferPage> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOfferPage> {
  OfferModal _modal = OfferModal();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    _modal = args as OfferModal;

    var photo = _modal.photo;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Offers'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        ImagePickerWidget(
          photo:_modal.photo,
          upload: Upload.OFFER,
          name:_modal.documentId,
          assets: 'assets/default/offer.jpg',
          updated: (String? path) => setState(() {
            _modal.photo = path;
            print('OFFER done ${_modal.photo}');
          }),
        ),
        SizedBox(height: 18),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Offer Name',
            helperText: '',
          ),
          keyboardType: TextInputType.name,
          onChanged: (String value) => _modal.name = value,
          controller: TextEditingController(text: _modal.name),
        ),
        TextFormField(
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: 'Description',
            helperText: '',
          ),
          keyboardType: TextInputType.multiline,
          onChanged: (String value) => _modal.description = value,
          controller: TextEditingController(text: _modal.description),
        ),
        EditButton('Keywords', left: 0, right: 0, bottom: 12,
            onPressed: () async {
              var _result = await Navigator.pushNamed(
                context,
                BUSINESS_KEYWORDS,
                arguments: _modal.keywords,
              );
              if (_result != null) {
                _modal.keywords = _result as List<String>;
                setState(() => print('offers keywords'));
              }
            }),
        Container(
          margin: EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Wrap(
            children: _modal.keywords
                .map((keyword) => Container(
              margin: EdgeInsets.all(6),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                keyword,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ))
                .toList(),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_modal.name?.isEmpty ?? true) {
              _showSnackBar(context, 'Name Can\'t be empty');
              return;
            }
            if (_modal.description?.isEmpty ?? true) {
              _showSnackBar(context, 'Description Can\'t be empty');
              return;
            }

            showCenterLoader(context);
            var db = FirestoreService();
            await db.offers.doc(_modal.documentId).update(_modal.toJson());
            Navigator.of(context, rootNavigator: true).pop(true);
            print('offers => $_modal');
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
