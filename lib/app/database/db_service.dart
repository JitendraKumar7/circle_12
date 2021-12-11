import 'package:circle/app/api/api_client.dart' as api;
import 'package:circle/modal/modal.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

const _OFFERS = 'Offers';
const _CIRCLES = 'Circles';
const _PROFILE = 'Profile';
const _COMMENT = 'Comment';
const _FEEDBACK = 'Feedback';
const _CATEGORY = 'Category';

const _REQUEST = 'Request';
const _MEMBERS = 'Members';
const _VIEWERS = 'Viewers';
const _BROADCAST = 'Broadcast';
const _NOTIFICATIONS = 'Notifications';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._();

  CollectionReference<OfferModal> get offers =>
      _firestore.collection(_OFFERS).withConverter<OfferModal>(
            fromFirestore: (snapshot, _) =>
                OfferModal.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<FeedbackModal> get feedback =>
      _firestore.collection(_FEEDBACK).withConverter<FeedbackModal>(
            fromFirestore: (snapshot, _) =>
                FeedbackModal.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<CircleModal> get circle =>
      _firestore.collection(_CIRCLES).withConverter<CircleModal>(
            fromFirestore: (snapshot, _) =>
                CircleModal.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<ProfileModal> get profile =>
      _firestore.collection(_PROFILE).withConverter<ProfileModal>(
            fromFirestore: (snapshot, _) =>
                ProfileModal.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<CategoryModal> get category =>
      _firestore.collection(_CATEGORY).withConverter<CategoryModal>(
            fromFirestore: (snapshot, _) =>
                CategoryModal.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<Notifications> get notifications =>
      _firestore.collection(_NOTIFICATIONS).withConverter<Notifications>(
            fromFirestore: (snapshot, _) =>
                Notifications.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<ContactModal> contactConverter(
      CollectionReference<Map<String, dynamic>> _reference) {
    return _reference.withConverter<ContactModal>(
      fromFirestore: (snapshot, _) => ContactModal.fromJson(snapshot.data()),
      toFirestore: (model, _) => model.toJson(),
    );
  }

  Future<bool> sendNotifications({
    required ContactModal contact,
    required QueryDocumentSnapshot<CircleModal> snapshot,
  }) async {
    var circle = snapshot.data();
    var admin = await profile.doc(circle.createdBy).get();

    //\\https://konnectmycircle.com
    var message = 'Hey congrats !\n\n'
        '${admin.get('name')?.toUpperCase()} has added your mobile no. ${contact.phone} in a business circle ${circle.name?.toUpperCase()} to promote your business among his friends and family.'
        '\n\nlogin now in circle app with same mobile number to view multiple business in many other circles .'
        '\n\nhttps://konnectmycircle.com?circle=${snapshot.id}';

    api.sendWhatsAppMessage(contact.phone, message);

    await Future.forEach(circle.references, (String viewerId) async {
      var notify = Notifications(
          senderId: contact.reference,
          viewerId: viewerId,
          type: 'addContact',
          title: 'NEW CIRCLE MEMBER JOINED',
          message:
              'has just now added a new member ${contact.phone} in ${circle.name?.toUpperCase()} in ${contact.category}.');

      increment(viewerId, 'notificationCounter');
      await notifications.add(notify);
    });
    return true;
  }

  CollectionReference<BroadcastModal> broadcast(
          DocumentReference<CircleModal> _reference) =>
      _reference.collection(_BROADCAST).withConverter<BroadcastModal>(
            fromFirestore: (snapshot, _) =>
                BroadcastModal.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<ContactModal> request(
          DocumentReference<CircleModal> _reference) =>
      contactConverter(_reference.collection(_REQUEST));

  CollectionReference<ContactModal> members(
          DocumentReference<CircleModal> _reference) =>
      contactConverter(_reference.collection(_MEMBERS));

  CollectionReference<ContactModal> viewers(
          DocumentReference<CircleModal> _reference) =>
      contactConverter(_reference.collection(_VIEWERS));

  CollectionReference<OfferComment> offerComment(
          DocumentReference<OfferModal> _reference) =>
      _reference.collection(_COMMENT).withConverter<OfferComment>(
            fromFirestore: (snapshot, _) =>
                OfferComment.fromJson(snapshot.data()),
            toFirestore: (model, _) => model.toJson(),
          );

  //
  void increment(String id, String key) {
    profile.doc(id).update({key: FieldValue.increment(1)});
  }

  void profileUpdate(id, String key) {
    profile.doc(id).update({key: 0});
  }
}
