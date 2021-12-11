import 'dart:convert';

class BusinessContactModal {
  String? phoneNumber;
  String? countryCode;

  String get phone => '$countryCode$phoneNumber';

  BusinessContactModal({
    String? phoneNumber,
    String? countryCode,
  }) {
    this.phoneNumber = phoneNumber;
    this.countryCode = countryCode;
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['countryCode'] = countryCode;
    json['phoneNumber'] = phoneNumber;
    return json;
  }

  BusinessContactModal.fromJson(Map<String, dynamic>? json) {
    if(json!=null) {
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
  }
  }

  @override
  String toString() => jsonEncode(toJson());
}
