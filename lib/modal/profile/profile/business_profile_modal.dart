import 'dart:convert';

class BusinessProfileModal {
  String? id;
  String? banner;
  String? description;
  String? businessCategory;
  String? organizationName;

  bool isActive = true;

  BusinessProfileModal({
    String? banner,
    String? description,
    String? businessType,
    String? businessCategory,
    String? organizationName,
    bool isActive = true,
  }) {
    this.banner = banner;
    this.isActive = isActive;
    this.description = description;
    this.businessCategory = businessCategory;
    this.organizationName = organizationName;
  }

  bool get isEmpty =>
      (businessCategory?.isEmpty ?? true) ||
      (organizationName?.isEmpty ?? true);

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['organizationName'] = organizationName;
    json['businessCategory'] = businessCategory;
    json['description'] = description;
    json['isActive'] = isActive;
    json['banner'] = banner;
    return json;
  }

  BusinessProfileModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      organizationName = json['organizationName'];
      businessCategory = json['businessCategory'];
      description = json['description'];
      isActive = json['isActive'];
      banner = json['banner'];
    }
  }

  @override
  String toString() => jsonEncode(toJson());
}
