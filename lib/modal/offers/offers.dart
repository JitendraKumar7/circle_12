import 'package:circle/modal/base/modal.dart';

class OfferModal extends BaseModal {
  String? name;
  String? type;
  String? photo;
  String? createdBy;
  String? description;
  List<String> views = [];
  List<String> likes = [];
  List<String> comments = [];
  List<String> keywords = [];

  OfferModal({
    String? name,
    String? type,
    String? photo,
    String? createdBy,
    String? description,
  }) {
    this.name = name;
    this.type = type;
    this.photo = photo;
    this.createdBy = createdBy;
    this.description = description;
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['description'] = description;
    json['documentId'] = documentId;
    json['timestamp'] = timestamp;
    json['createdBy'] = createdBy;
    json['keywords'] = keywords;
    json['comments'] = comments;
    json['views'] = views;
    json['likes'] = likes;
    json['photo'] = photo;
    json['type'] = type;
    json['name'] = name;
    return json;
  }

  OfferModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      keywords = json['keywords'].cast<String>();
      //comments = json['comments'].cast<String>();
      //views = json['views'].cast<String>();
      //likes = json['likes'].cast<String>();

      description = json['description'];
      documentId = json['documentId'];
      timestamp = json['timestamp'];
      createdBy = json['createdBy'];
      photo = json['photo'];
      type = json['type'];
      name = json['name'];
    }
  }

  final items = ['Business', 'Sale Purchase', 'Social', 'Family'];
}
