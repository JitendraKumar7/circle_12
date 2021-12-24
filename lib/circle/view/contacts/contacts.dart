import 'package:circle/app/app.dart';
import 'package:circle/constant/constant.dart';
import 'package:circle/home/index.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class ContactsPage extends StatefulWidget {
  final QueryDocumentSnapshot<CircleModal> snapshot;
  final List<ContactModal> contacts;

  const ContactsPage(
    this.contacts, {
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsState(contacts);
}

class _ContactsState extends State<ContactsPage> {
  var db = FirestoreService();

  final int pages;
  int currentPages = 0;

  _ContactsState(contacts)
      : this.contacts = contacts,
        pages = (contacts.length / 10).ceil();

  final List<ContactModal> contacts;
  late String userId;

  @override
  Widget build(BuildContext context) {
    userId = context.read<ProfileModal>().id ?? '';
    return contacts.isEmpty
        ? Center(
            child: Text(
            'No Record Found',
            style: TextStyle(fontWeight: FontWeight.bold),
          ))
        : Column(children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 18, left: 9, right: 9),
                children: contacts
                    .skip(currentPages * 10)
                    .take(10)
                    .map(_getContactItem)
                    .toList(),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(
                onPressed: () => setState(() {
                  if (currentPages > 0) currentPages -= 1;
                }),
                icon: Icon(Icons.arrow_back_ios),
              ),
              Text('$currentPages/$pages Pages'),
              IconButton(
                onPressed: () => setState(() {
                  if (pages > currentPages + 1) currentPages += 1;
                }),
                icon: Icon(Icons.arrow_forward_ios),
              ),
              SizedBox(width: 24)
            ])
          ]);
  }

  Widget _getContactItem(ContactModal contact) {
    var profile = contact.profileModal;
    var location = profile.businessLocation;
    return Card(
      margin: EdgeInsets.only(bottom: 6),
      child: Container(
        padding: EdgeInsets.all(6),
        child: InkWell(
          onTap: () {
            if (contact.referenceId != null)
              Navigator.pushNamed(
                context,
                VIEW_PROFILE,
                arguments: contact.referenceId,
              );
          },
          child: Row(children: [
            Avatar(
              avatarSize: 18,
              photo: profile.profile,
            ),
            SizedBox(width: 9),
            Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    '${profile.name ?? contact.name}'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('  ${profile.getBusinessCategory ?? contact.category}'),
                  if (!profile.businessLocation.isEmpty)
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on,
                              size: 18, color: Colors.green),
                          Expanded(
                            child: Text(
                              '${location.subLocality ?? ''} ${location.locality ?? ''} ${location.postalCode ?? ''}',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12),
                              softWrap: true,
                            ),
                          ),
                        ]),
                ])),
            Column(children: [
              contact.referenceId == null
                  ? SizedBox.shrink()
                  : FutureBuilder(
                      future: db.offers
                          .where('createdBy', isEqualTo: contact.referenceId)
                          .get(),
                      builder: (_,
                          AsyncSnapshot<QuerySnapshot<OfferModal>> snapshot) {
                        var offerCount = snapshot.data?.size ?? 0;
                        return offerCount == 0
                            ? SizedBox.shrink()
                            : Row(children: [
                                Icon(Icons.local_offer,
                                    size: 12, color: Colors.pink),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    LIST_OFFER,
                                    arguments: snapshot.data,
                                  ),
                                  child: Text(
                                    '$offerCount Offer',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.red),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(6),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              ]);
                      },
                    ),
              if (contact.isAdmin)
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Admin',
                    style: TextStyle(fontSize: 10),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(3),
                    minimumSize: Size.zero,
                    primary: Colors.blue[300],
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ]),
            PopupMenuButton<String>(
              onSelected: (String value) async {
                var whatsapp = contact.phone.replaceAll('+', '');
                switch (value) {
                  case 'Call':
                    await launch('tel://${contact.phone}');
                    break;
                  case 'Chat':
                    loadConversion(
                      context,
                      userId,
                      contact.referenceId,
                      contact.name,
                    );
                    break;
                  case 'View':
                    Navigator.pushNamed(
                      context,
                      VIEW_CONTACT,
                      arguments: contact,
                    );
                    break;
                  case 'Share':
                    Share.share(
                      getProfileShare(
                        contact,
                        widget.snapshot.data().name,
                      ),
                      subject: 'CircleApp',
                    );
                    break;
                  case 'Invite':
                    await WhatsappShare.share(
                      text: SHARE_APP_MESSAGE,
                      //package : Package.businessWhatsapp,
                      phone: whatsapp,
                    );
                    break;
                  case 'Delete':
                    contacts.remove(contact);
                    var reference = db.members(widget.snapshot.reference);
                    setState(() => print('${contact.phoneNumber} deleted'));
                    await reference.doc(contact.phoneNumber).delete();
                    break;
                  default:
                    print(value);
                    break;
                }
              },
              itemBuilder: (_) => _getOptions(contact),
            ),
          ]),
        ),
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: TextButton.icon(
        icon: Icon(icon, color: Colors.black),
        onPressed: null,
        label: Text(
          value,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _getOptions(ContactModal _modal) {
    var circleId = widget.snapshot.data().createdBy;
    return [
      if (_modal.isNotPrivate || _modal.isActive) _menuItem('Call', Icons.call),

      // chat
      if (_modal.referenceId != null && _modal.referenceId != userId)
        _menuItem('Chat', Icons.message),

      // view
      _menuItem('View', Icons.visibility),

      // view
      _menuItem('Share', Icons.share),

      // Send invite
      _menuItem('Invite', Icons.send),

      // is Deletable
      if (_modal.isDeletable(userId) || circleId == userId)
        _menuItem('Delete', Icons.delete),
    ];
  }
}
