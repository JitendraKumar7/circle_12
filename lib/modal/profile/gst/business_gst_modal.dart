import 'dart:convert';

class BusinessGstModal {
  bool visible = false;
  String? number;

  BusinessGstModal();

  BusinessGstModal.fromJson(Map<String, dynamic>? json) {
    if(json!=null) {
      visible = json['visible'];
      number = json['number'];
    }
  }

  bool get isNotEmpty => number == null ? false : number!.isNotEmpty;

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['visible'] = visible;
    data['number'] = number;
    return data;
  }

  @override
  String toString() => jsonEncode(toJson());
}
