import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class MessageUser {
  var message;
  var fileUrl;
  var imageUrl;
  var senderId;
  var timestamp;

  var currentUserId;
  bool get isSender => currentUserId == senderId;

  MessageUser(
    this.message,
    this.senderId,
  ) : timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['timestamp'] = timestamp;
    json['senderId'] = senderId;
    json['imageUrl'] = imageUrl;
    json['fileUrl'] = fileUrl;
    json['message'] = message;
    return json;
  }

  var key;

  MessageUser.fromJson(DataSnapshot data) {
      timestamp = data.value['timestamp'];
      senderId = data.value['senderId'];
      imageUrl = data.value['imageUrl'];
      fileUrl = data.value['fileUrl'];
      message = data.value['message'];
      key = data.key;
  }

  @override
  String toString() => jsonEncode(toJson());
}

// first user check second user
