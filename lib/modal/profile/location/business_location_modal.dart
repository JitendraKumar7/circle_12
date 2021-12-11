import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessLocationModal {
  String? locality;
  String? adminArea;
  String? postalCode;
  String? addressLine;
  String? countryName;
  String? countryCode;
  String? featureName;
  String? subLocality;
  String? subAdminArea;
  String? adminAreaCode;

  double? latitude;
  double? longitude;

  bool get isEmpty => latitude == null || longitude == null;

  LatLng get latLng => LatLng(latitude ?? 28.5623, longitude ?? 77.5623);

  String get navigation =>
      'https://maps.google.com/?q=${latitude?.toStringAsFixed(6)},${longitude?.toStringAsFixed(6)}';

  BusinessLocationModal();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['adminAreaCode'] = adminAreaCode;
    data['subAdminArea'] = subAdminArea;
    data['subLocality'] = subLocality;
    data['featureName'] = featureName;
    data['countryCode'] = countryCode;
    data['countryName'] = countryName;
    data['addressLine'] = addressLine;
    data['postalCode'] = postalCode;
    data['adminArea'] = adminArea;
    data['locality'] = locality;

    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }

  BusinessLocationModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      adminAreaCode = json['adminAreaCode'];
      subAdminArea = json['subAdminArea'];
      subLocality = json['subLocality'];
      featureName = json['featureName'];
      countryCode = json['countryCode'];
      countryName = json['countryName'];
      addressLine = json['addressLine'];
      postalCode = json['postalCode'];
      adminArea = json['adminArea'];
      locality = json['locality'];

      longitude = json['longitude'];
      latitude = json['latitude'];
    }
  }

  @override
  String toString() => jsonEncode(toJson());
}
