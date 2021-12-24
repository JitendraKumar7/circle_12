import 'package:circle/modal/base/modal.dart';
import 'package:circle/modal/modal.dart';

class ContactModal extends BaseModal {
  String? name;
  String? type;
  String? houseNo;
  String? category;
  String? reference; // member id who add this contact (Admin ID)
  String? referenceId; // member profile id if member register (Profile ID)
  String? phoneNumber;
  String? countryCode;

  var inActive = ['house wife', 'housewife', 'home maker', 'homemaker'];

  bool get isNotPrivate => !inActive.contains(category?.toLowerCase());

  bool get isNotEmpty =>
      (name?.isNotEmpty ?? false) &&
      (category?.isNotEmpty ?? false) &&
      (phoneNumber?.isNotEmpty ?? false) &&
      (countryCode?.isNotEmpty ?? false);

  bool isDeletable(String? id) => reference == id;

  bool get isActive => profileModal.isActive;

  bool get isAdmin => reference == referenceId;

  bool isType(String value) => type == value;

  ProfileModal profileModal = ProfileModal();

  String get phone => '$countryCode$phoneNumber';

  ContactModal({
    String? name,
    String? type,
    String? houseNo,
    String? category,
    String? reference,
    String? referenceId,
    String? phoneNumber,
    String? countryCode,
  }) {
    this.name = name;
    this.type = type ?? 'Members';
    this.houseNo = houseNo;
    this.category = category;
    this.reference = reference;
    this.referenceId = referenceId;
    this.phoneNumber = phoneNumber;
    this.countryCode = countryCode;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['countryCode'] = countryCode;
    json['phoneNumber'] = phoneNumber;
    json['referenceId'] = referenceId;
    json['reference'] = reference;
    json['timestamp'] = timestamp;
    json['category'] = category;
    json['houseNo'] = houseNo;
    json['name'] = name;
    json['type'] = type;
    return json;
  }

  ContactModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      countryCode = json['countryCode'];
      phoneNumber = json['phoneNumber'];
      referenceId = json['referenceId'];
      timestamp = json['timestamp'];
      reference = json['reference'];
      category = json['category'];
      houseNo = json['houseNo'];
      name = json['name'];
      type = json['type'];
    }
  }
}
