import 'package:circle/app/app.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessInfoPage extends StatefulWidget {
  @override
  State<BusinessInfoPage> createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfoPage> {
  var businessProfile = BusinessProfileModal();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessProfile = args as BusinessProfileModal;
      setState(() => print('done'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'.toUpperCase())),
      body: ListView(children: [
        ImagePickerWidget(
          upload: Upload.BANNER,
          name: businessProfile.id,
          photo: businessProfile.banner,
          assets: 'assets/default/business.jpg',
          updated: (String? path) => setState(() {
            businessProfile.banner = path;
            print('CIRCLE done ${businessProfile.banner}');
          }),
        ),
        EditTextForm(
          'Organization Name',
          businessProfile.organizationName,
          onChanged: (value) => businessProfile.organizationName = value,
          readOnly: false,
          top: 18,
        ),
        CategoryForm(
          editable: true,
          selectedItem: businessProfile.businessCategory,
          onChanged: (value) => businessProfile.businessCategory = value,
        ),
        EditTextForm(
          'Description',
          businessProfile.description,
          onChanged: (value) => businessProfile.description = value,
          readOnly: false,
        ),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, businessProfile),
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18),
              padding: EdgeInsets.all(12),
                minimumSize: Size(180, 45),
                primary: Colors.blue[300]),
            child: Text('UPDATE'),
          ),
        ),
      ]),
    );
  }
}
