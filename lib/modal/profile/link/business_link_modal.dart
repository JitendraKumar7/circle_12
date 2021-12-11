import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget _getIcon(String? value) {
  if (value == 'Konnect My Business') {
    return SizedBox(
      height: 24,
      width: 24,
      child: Image.asset('assets/ic_kmb.png'),
    );
  }
  if (value == 'Instagram') {
    return FaIcon(
      FontAwesomeIcons.instagram,
      color: Color(0xFF833AB4),
    );
  }
  if (value == 'Pinterest') {
    return FaIcon(
      FontAwesomeIcons.pinterest,
      color: Color(0xFFE60023),
    );
  }
  if (value == 'Facebook') {
    return FaIcon(
      FontAwesomeIcons.facebook,
      color: Color(0xFF3B5998),
    );
  }
  if (value == 'WhatsApp') {
    return FaIcon(
      FontAwesomeIcons.whatsapp,
      color: Color(0xFF4FCE5D),
    );
  }
  if (value == 'LinkedIn') {
    return FaIcon(
      FontAwesomeIcons.linkedin,
      color: Color(0xFF0E76A8),
    );
  }
  if (value == 'Telegram') {
    return FaIcon(
      FontAwesomeIcons.telegram,
      color: Color(0xFF0088CC),
    );
  }
  if (value == 'Twitter') {
    return FaIcon(
      FontAwesomeIcons.twitter,
      color: Color(0xFF00ACEE),
    );
  }
  if (value == 'YouTube') {
    return FaIcon(
      FontAwesomeIcons.youtube,
      color: Color(0xFFC4302B),
    );
  }
  if (value == 'Skype') {
    return FaIcon(
      FontAwesomeIcons.skype,
      color: Color(0xFF0493FA),
    );
  }
  return FaIcon(
    Icons.language,
    color: Color(0xFF0493FA),
  );
}

var linkTypes = [
  'Konnect My Business',
  'Instagram',
  'Pinterest',
  'Facebook',
  'WhatsApp',
  'LinkedIn',
  'Telegram',
  'Twitter',
  'YouTube',
  'Skype',
  'Web',
];

class BusinessLinkModal {
  String? type;
  String? link;

  BusinessLinkModal({this.type, this.link});

  Widget get icon => _getIcon(type);

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['type'] = this.type;
    data['link'] = this.link;
    return data;
  }

  BusinessLinkModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      type = json['type'];
      link = json['link'];
    }
  }

  @override
  String toString() => jsonEncode(toJson());
}
