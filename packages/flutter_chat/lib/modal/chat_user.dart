import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class ChatUser {
  var name;
  var profile;
  var message;
  var timestamp;
  var referenceId;

  var currentUserId;
  var conversionUserId;

  ChatUser(
    this.currentUserId,
    this.conversionUserId,
  )   : referenceId = Uuid().v1(),
        timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['conversionUserId'] = conversionUserId;
    json['currentUserId'] = currentUserId;
    json['referenceId'] = referenceId;
    json['timestamp'] = timestamp;
    json['message'] = message;
    json['name'] = name;
    return json;
  }

  Map<String, dynamic> toUpdate() {
    var json = Map<String, dynamic>();
    json['timestamp'] = timestamp;
    json['message'] = message;
    return json;
  }

  Map<String, dynamic> currentJson() {
    var json = Map<String, dynamic>();

    json['conversionUserId'] = conversionUserId;
    json['currentUserId'] = currentUserId;
    json['referenceId'] = referenceId;
    json['timestamp'] = timestamp;
    json['message'] = message;
    return json;
  }

  Map<String, dynamic> conversionJson() {
    var json = Map<String, dynamic>();

    json['conversionUserId'] = currentUserId;
    json['currentUserId'] = conversionUserId;

    json['referenceId'] = referenceId;
    json['timestamp'] = timestamp;
    json['message'] = message;
    return json;
  }

  ChatUser.fromJson(DataSnapshot data) {
    conversionUserId = data.value['conversionUserId'];
    currentUserId = data.value['currentUserId'];
    referenceId = data.value['referenceId'];
    timestamp = data.value['timestamp'];
    message = data.value['message'];
  }

  @override
  String toString() => jsonEncode(toJson());
}

// first user check second user
