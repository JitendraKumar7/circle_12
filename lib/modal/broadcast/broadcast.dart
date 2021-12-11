import 'package:circle/modal/base/modal.dart';

class BroadcastModal extends BaseModal {
  String? name;
  String? file;
  String? photo;
  String? description;

  String? errorName;
  String? errorFile;
  String? errorPhoto;
  String? errorDescription;

  BroadcastModal({
    String? name,
    String? file,
    String? photo,
    String? description,
  }) {
    this.name = name;
    this.file = file;
    this.photo = photo;
    this.description = description;
  }

  bool get hasError {
    errorName = null;
    errorDescription = null;

    if (name?.isEmpty ?? true) {
      errorName = 'name is required';
      return true;
    }

    if ((photo?.isEmpty ?? true) && (description?.isEmpty ?? true)) {
      errorDescription = 'photo or description any one required';
      return true;
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['description'] = description;
    json['documentId'] = documentId;
    json['timestamp'] = timestamp;
    json['photo'] = photo;
    json['file'] = file;
    json['name'] = name;
    return json;
  }

  BroadcastModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      description = json['description'];
      documentId = json['documentId'];
      timestamp = json['timestamp'];
      photo = json['photo'];
      file = json['file'];
      name = json['name'];
    }
  }
}
