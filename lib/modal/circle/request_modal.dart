import 'package:circle/modal/modal.dart';

class CircleRequestModal {
  QueryDocumentSnapshot<CircleModal> snapshot;
  ContactModal contact;
  CircleModal circle;

  DocumentReference<CircleModal> get reference => snapshot.reference;

  CircleRequestModal({
    required this.snapshot,
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
