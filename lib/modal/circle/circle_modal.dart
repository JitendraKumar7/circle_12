import 'package:circle/modal/base/modal.dart';

class CircleModal extends BaseModal {
  String? name;
  String? type;
  String? profile;
  String? createdBy;
  String? description;

  List<String> request = [];
  List<String> members = [];
  List<String> viewers = [];
  List<String> references = [];

  bool isHouseNo = false;
  bool isAddMember = true;
  bool isAllowVendor = false;
  bool isAdminApproval = false;
  bool isAllowGatePass = false;
  bool isAllowEmergencies = false;

  CircleModal({
    String? name,
    String? type,
    String? profile,
    String? createdBy,
    String? description,
  }) {
    this.name = name;
    this.profile = profile;
    this.createdBy = createdBy;

    this.type = type ?? items[0];
    this.description = description ?? descriptions[this.type];
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map<String, dynamic>();
    json['description'] = description;
    json['documentId'] = documentId;
    json['timestamp'] = timestamp;
    json['createdBy'] = createdBy;
    json['profile'] = profile;
    json['type'] = type;
    json['name'] = name;

    json['request'] = request;
    json['members'] = members;
    json['viewers'] = viewers;
    json['references'] = references;

    json['isHouseNo'] = isHouseNo;
    json['isAddMember'] = isAddMember;
    json['isAllowVendor'] = isAllowVendor;
    json['isAdminApproval'] = isAdminApproval;
    json['isAllowGatePass'] = isAllowGatePass;
    json['isAllowEmergencies'] = isAllowEmergencies;
    return json;
  }

  CircleModal.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      description = json['description'];
      documentId = json['documentId'];
      timestamp = json['timestamp'];
      createdBy = json['createdBy'];
      profile = json['profile'];
      type = json['type'];
      name = json['name'];

      request = json['request']?.cast<String>() ?? [];
      members = json['members']?.cast<String>() ?? [];
      viewers = json['viewers']?.cast<String>() ?? [];
      references = json['references']?.cast<String>() ?? [];

      isHouseNo = json['isHouseNo'];
      isAddMember = json['isAddMember'];
      isAllowVendor = json['isAllowVendor'];
      isAdminApproval = json['isAdminApproval'];
      isAllowGatePass = json['isAllowGatePass'];
      isAllowEmergencies = json['isAllowEmergencies'];
    }
  }

  bool get isSocial => type == 'Social';

  bool get isFamily => type == 'Family';

  bool get isBusiness => type == 'Business';

  final items = ['Business', 'Social', 'Family'];

  final Map<String, String> descriptions = {
    'Family': 'I  have created this list to link all our family members in any business or profession.\n'
        'Added members can also  add new members in the  family tree.\n'
        'Members can add  anybody  from mother, father or in-laws side.\n'
        'Members in job, business, profession or studying can  create a profile.\n'
        'Search for goods and services within  family.\n'
        'Doing  business within  family is  a  win win for  both seller and buyer.\n',
    'Social': 'I have created this list  to  link & promote business and profession of all members in our society/club/group/organisation\n'
        'Update business or professional profile.\n'
        'You can add new members in the list too.\n'
        'This app also helps  buyers to Search products & services within list\n'
        'Persons in  pvt or govt job  can also join here and create his profile.\n',
    'Business': 'I have created  this list to promote your  business & profession through  this  app among my friends, family, neighbours & associates.\n'
        '\nReach out  to  new customers by updating your profile. Add  important information about your business. Add  business keywords.\n'
        '\nThe option of GST & BANKING   gives extra confidence to customers.\n',
  };

  bool canAddMember(String userId) {
    return isAddMember || createdBy == userId;
  }
}
