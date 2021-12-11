import 'dart:ui';

import 'package:circle/modal/modal.dart';
import 'package:flutter/material.dart';

class UpdateDocument {
  DocumentReference<ProfileModal> _reference;
  VoidCallback onUpdated;

  UpdateDocument(
    this._reference, {
    required this.onUpdated,
  });

  updateKeywords(List<String> list) async {
    await _reference.update({'businessKeywords': list});
    print('Keywords update successfully!!');
    onUpdated();
  }

  updateCatalogue(List<String> list) async {
    await _reference.update({'businessCatalogue': list});
    print('Catalogue update successfully!!');
    onUpdated();
  }

  updateGst(Map<String, dynamic> params) async {
    await _reference.update({'businessGst': params});
    print('Gst update successfully!!');
    onUpdated();
  }

  updateLinks(List<BusinessLinkModal> list) async {
    var params = list.map((item) => item.toJson()).toList();
    await _reference.update({'businessLinks': params});
    print('Links update successfully!!');
    onUpdated();
  }

  updateBanks(List<BusinessBankModal> list) async {
    var params = list.map((item) => item.toJson()).toList();
    await _reference.update({'businessBanks': params});
    print('Banks update successfully!!');
    onUpdated();
  }

  updateEmails(List<String> list) async {
    await _reference.update({'businessEmails': list});
    print('Emails update successfully!!');
    onUpdated();
  }

  updateContacts(List<BusinessContactModal> list) async {
    var params = list.map((item) => item.toJson()).toList();
    await _reference.update({'businessContacts': params});
    print('Contacts update successfully!!');
    onUpdated();
  }

  updateProfile(Map<String, dynamic> businessProfile) async {
    await _reference.update({'businessProfile': businessProfile});
    print('Profile update successfully!!');
    onUpdated();
  }

  updateLocation(Map<String, dynamic> businessLocation) async {
    await _reference.update({'businessLocation': businessLocation});
    print('Location update successfully!!');
    onUpdated();
  }
}

class EditButton extends StatelessWidget {
  final String label;
  final Color? color;
  final Widget? icon;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final TextStyle? style;
  final VoidCallback? onPressed;

  EditButton(
    this.label, {
    Key? key,
    this.icon,
    this.style,
    this.color,
    this.onPressed,
    this.top = 0.0,
    this.left = 12.0,
    this.right = 12.0,
    this.bottom = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        padding: EdgeInsets.only(
          left: 12,
          top: 6,
          right: 12,
          bottom: 6,
        ),
        decoration: BoxDecoration(
          color: color ?? Colors.blue[50],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: style ??
                  TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            onPressed != null || icon != null
                ? IconButton(
                    onPressed: onPressed,
                    icon: icon ??
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                  )
                : SizedBox.square(dimension: 42),
          ],
        ),
      );
}

class EditTextForm extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? value;
  final String label;

  final double top;
  final double left;
  final double right;
  final double bottom;

  final bool readOnly;

  EditTextForm(
    this.label,
    this.value, {
    Key? key,
    this.onChanged,
    this.decoration,
    this.top = 0.0,
    this.left = 12.0,
    this.right = 12.0,
    this.bottom = 0.0,
    this.keyboardType,
    this.readOnly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
        ),
        child: TextFormField(
          autofocus: false,
          readOnly: readOnly,
          enabled: !readOnly,
          onChanged: onChanged,
          keyboardType: keyboardType,
          controller: TextEditingController(text: value),
          decoration: decoration ??
              InputDecoration(
                labelText: label.toUpperCase(),
                helperText: '',
                filled: true,
                fillColor: Colors.blue[50],
                floatingLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
        ),
      );
}
