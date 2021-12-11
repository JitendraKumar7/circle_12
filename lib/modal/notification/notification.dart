import '../../modal/base/modal.dart';

class Notifications extends BaseModal {
  var type;
  var title;
  var message;
  var viewerId;
  var senderId;

  Notifications({
    this.type,
    this.title,
    this.message,
    this.viewerId,
    this.senderId,
  });

  @override
  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['documentId'] = documentId;
    json['timestamp'] = timestamp;
    json['viewerId'] = viewerId;
    json['senderId'] = senderId;
    json['message'] = message;
    json['title'] = title;
    json['type'] = type;
    return json;
  }

  Notifications.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      documentId = json['documentId'];
      timestamp = json['timestamp'];
      viewerId = json['viewerId'];
      senderId = json['senderId'];
      message = json['message'];
      title = json['title'];
      type = json['type'];
    }
  }
}
