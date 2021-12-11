import 'package:circle/modal/base/modal.dart';

class CategoryModal extends BaseModal {
  String? name;


  CategoryModal(this.name);

  @override
  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['timestamp'] = timestamp;
    json['name'] = name;
    return json;
  }

  CategoryModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      timestamp = json['timestamp'];
      name = json['name'];
    }
  }
}
