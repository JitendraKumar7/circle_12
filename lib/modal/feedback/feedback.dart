import 'package:circle/modal/base/modal.dart';
import 'package:circle/modal/modal.dart';

class FeedbackModal extends BaseModal {
  String? reference;
  String? message;

  FeedbackModal();

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['documentId'] = documentId;
    json['reference'] = reference;
    json['timestamp'] = timestamp;
    json['message'] = message;
    return json;
  }

  FeedbackModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      documentId = json['documentId'];
      reference = json['reference'];
      timestamp = json['timestamp'];
      message = json['message'];
    }
  }
}
