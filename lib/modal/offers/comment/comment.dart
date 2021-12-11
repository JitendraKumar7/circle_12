import 'package:circle/modal/base/modal.dart';
import 'package:flutter/material.dart';

class OfferComment extends BaseModal {
  String? userId;
  String? comment;
  String? userName;
  List<String> reply = [];


  var controller = TextEditingController();

  OfferComment({
    this.userId,
    this.comment,
    this.userName,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['timestamp'] = timestamp;
    json['userName'] = userName;
    json['comment'] = comment;
    json['reply'] = reply;
    json['id'] = userId;
    return json;
  }

  OfferComment.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      timestamp = json['timestamp'];
      userName = json['userName'];
      comment = json['comment'];
      reply = json['reply'].cast<String>();
      userId = json['userId'];
    }
  }
}
