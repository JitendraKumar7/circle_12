import 'dart:convert';

import 'package:circle/modal/profile/profile.dart';
import 'package:flutter/material.dart';


class ProfileModal extends ChangeNotifier {
  String? id; // Document ID or User Registered ID (User ID)
  String? name;
  String? email;
  String? profile;
  String? phoneNumber;
  String? countryCode;

  int offerCounter = 0;
  int notificationCounter = 0;

  String get phone => '$countryCode$phoneNumber';

  List<String> businessEmails = [];
  List<String> businessKeywords = [];
  List<String> businessCatalogue = [];

  List<BusinessContactModal> businessContacts = [];

  List<BusinessLinkModal> businessLinks = [];
  List<BusinessBankModal> businessBanks = [];

  BusinessGstModal businessGst = BusinessGstModal();
  BusinessProfileModal businessProfile = BusinessProfileModal();
  BusinessLocationModal businessLocation = BusinessLocationModal();

  ProfileModal();

  bool get isActive => businessProfile.isActive;

  String? get getProfile => businessProfile.banner ?? profile;

  String? get getDescription => businessProfile.description;

  String? get getBusinessCategory => businessProfile.businessCategory;

  String? get getOrganizationName => businessProfile.organizationName;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['countryCode'] = countryCode;
    json['phoneNumber'] = phoneNumber;
    json['profile'] = profile;
    json['email'] = email;
    json['name'] = name;
    json['id'] = id;

    json['offerCounter'] = offerCounter;
    json['notificationCounter'] = notificationCounter;

    json['businessEmails'] = businessEmails;
    json['businessKeywords'] = businessKeywords;
    json['businessCatalogue'] = businessCatalogue;

    json['businessContacts'] = businessContacts.map((e) => e.toJson()).toList();

    json['businessLinks'] = businessLinks.map((e) => e.toJson()).toList();
    json['businessBanks'] = businessBanks.map((e) => e.toJson()).toList();

    json['businessGst'] = businessGst.toJson();
    json['businessProfile'] = businessProfile.toJson();
    json['businessLocation'] = businessLocation.toJson();

    return json;
  }

  ProfileModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      countryCode = json['countryCode'];
      phoneNumber = json['phoneNumber'];
      profile = json['profile'];
      email = json['email'];
      name = json['name'];
      id = json['id'];

      offerCounter = json['offerCounter'] ?? 0;
      notificationCounter = json['notificationCounter'] ?? 0;


      // list [String]
      businessEmails = json['businessEmails'].cast<String>();
      // list [String]
      businessKeywords = json['businessKeywords'].cast<String>();
      // list [String]
      businessCatalogue = json['businessCatalogue'].cast<String>();

      // list [BusinessContactModal]
      businessContacts = json['businessContacts']
          .map<BusinessContactModal>((i) => BusinessContactModal.fromJson(i))
          .toList();

      // list [BusinessLinkModal]
      businessLinks = json['businessLinks']
          .map<BusinessLinkModal>((i) => BusinessLinkModal.fromJson(i))
          .toList();
      // list [BusinessBankModal]
      businessBanks = json['businessBanks']
          .map<BusinessBankModal>((i) => BusinessBankModal.fromJson(i))
          .toList();

      // object [BusinessGstModal]
      businessGst = BusinessGstModal.fromJson(json['businessGst']);
      // object [BusinessProfileModal]
      businessProfile = BusinessProfileModal.fromJson(json['businessProfile']);
      // object [BusinessLocationModal]
      businessLocation =
          BusinessLocationModal.fromJson(json['businessLocation']);
    }
  }

  void fromJsonProvider(Map<String, dynamic>? json) {
    if (json != null) {
      countryCode = json['countryCode'];
      phoneNumber = json['phoneNumber'];
      profile = json['profile'];
      email = json['email'];
      name = json['name'];
      id = json['id'];

      offerCounter = json['offerCounter'] ?? 0;
      notificationCounter = json['notificationCounter'] ?? 0;

      // list [String]
      businessEmails = json['businessEmails'].cast<String>();
      // list [String]
      businessKeywords = json['businessKeywords'].cast<String>();
      // list [String]
      businessCatalogue = json['businessCatalogue'].cast<String>();

      // list [BusinessContactModal]
      businessContacts = json['businessContacts']
          .map<BusinessContactModal>((i) => BusinessContactModal.fromJson(i))
          .toList();

      // list [BusinessLinkModal]
      businessLinks = json['businessLinks']
          .map<BusinessLinkModal>((i) => BusinessLinkModal.fromJson(i))
          .toList();
      // list [BusinessBankModal]
      businessBanks = json['businessBanks']
          .map<BusinessBankModal>((i) => BusinessBankModal.fromJson(i))
          .toList();

      // object [BusinessGstModal]
      businessGst = BusinessGstModal.fromJson(json['businessGst']);
      // object [BusinessProfileModal]
      businessProfile = BusinessProfileModal.fromJson(json['businessProfile']);
      // object [BusinessLocationModal]
      businessLocation =
          BusinessLocationModal.fromJson(json['businessLocation']);
    }
  }

  @override
  String toString() => jsonEncode(toJson());

  void listeners() => notifyListeners();

  _(String? value, String search) {
    if (value == null) return false;
    if (value.isNotEmpty) {
      return value.toLowerCase().contains(search.toLowerCase());
    }
    return false;
  }

  bool isExist(String value) {
    return _(name, value) ||
        _(phoneNumber, value) ||
        _(businessLocation.postalCode, value) ||
        _(businessProfile.organizationName, value) ||
        _(businessProfile.businessCategory, value) ||
        businessKeywords
            .any((e) => e.toLowerCase().contains(value.toLowerCase()));
  }
}
