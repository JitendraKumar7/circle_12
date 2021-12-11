import 'dart:convert';

import 'package:flutter/material.dart';

class BusinessBankModal {
  String? name;
  String? ifsc;
  String? number;
  String? branch;
  String? holder;
  String? upi;
  bool visible = false;
  bool isExpanded = false;

  BusinessBankModal();

  BusinessBankModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      name = json['name'];
      ifsc = json['ifsc'];
      number = json['number'];
      branch = json['branch'];
      holder = json['holder'];
      upi = json['upi'];
      visible = json['visible'];
    }
  }

  bool get isNotEmpty => name == null ||
          ifsc == null ||
          number == null ||
          branch == null ||
          holder == null
      ? false
      : name!.isNotEmpty ||
          ifsc!.isNotEmpty ||
          number!.isNotEmpty ||
          branch!.isNotEmpty ||
          holder!.isNotEmpty;

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['visible'] = visible;
    data['number'] = number;
    data['branch'] = branch;
    data['holder'] = holder;
    data['name'] = name;
    data['ifsc'] = ifsc;
    data['upi'] = upi;
    return data;
  }

  @override
  String toString() => jsonEncode(toJson());

  ExpansionPanel get getUI => ExpansionPanel(
        isExpanded: isExpanded,
        headerBuilder: (_, bool isExpanded) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          padding: EdgeInsets.only(left: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            name ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          padding: EdgeInsets.only(left: 12, bottom: 18),
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                Text(
                  'IFSC',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ifsc ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ]),
              TableRow(children: [
                Text(
                  'Number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  number ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ]),
              TableRow(children: [
                Text(
                  'Acc. Holder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  holder ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ]),
              TableRow(children: [
                Text(
                  'UPI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  upi ?? '',
                  style: TextStyle(fontSize: 18),
                ),
              ]),
            ],
          ),
        ),
      );
}
