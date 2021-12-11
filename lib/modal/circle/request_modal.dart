import 'package:circle/modal/modal.dart';

class CircleRequestModal {
  DocumentReference<CircleModal> reference;
  ContactModal contact;
  CircleModal circle;

  CircleRequestModal({
    required this.reference,
    required this.contact,
    required this.circle,
  });

/* CircleListModal({
    int? members,
    int? viewers,
    int? offers,
    ProfileModal? profile,
    QueryDocumentSnapshot<CircleModal>? circle,
  }) {
    this.circle = circle;
    this.offers = offers;
    this.profile = profile;
    this.members = members;
    this.viewers = viewers;
  }*/
}
