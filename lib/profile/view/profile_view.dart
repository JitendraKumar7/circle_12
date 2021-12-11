import 'package:circle/app/app.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/photo/photo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewPage extends StatefulWidget {
  @override
  State<ProfileViewPage> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileViewPage> {
  var _modal = ProfileModal();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var args = ModalRoute.of(context)?.settings.arguments;

      var db = FirestoreService();
      var id = args as String;

      var _profile = await db.profile.doc(id).get();
      if (_profile.exists) _modal = _profile.data()!;

      if (mounted) setState(() => print('_profile!.exists'));
    });
  }

  @override
  Widget build(BuildContext context) {
    var businessCatalogue = _modal.businessCatalogue;

    var businessEmails = _modal.businessEmails;
    var businessContacts = _modal.businessContacts;

    var businessLinks = _modal.businessLinks;
    var businessBanks = _modal.businessBanks;

    var businessGst = _modal.businessGst;
    var businessProfile = _modal.businessProfile;
    var businessLocation = _modal.businessLocation;

    return Scaffold(
      appBar: AppBar(title: Text('Business Profile'.toUpperCase())),
      body: _modal.id == null
          ? Center(child: CupertinoActivityIndicator())
          : ListView(children: [
              Stack(children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: (businessProfile.banner == null
                              ? AssetImage('assets/default/business.jpg')
                              : NetworkImage(businessProfile.banner!))
                          as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  color: Colors.black26,
                  alignment: Alignment(-0.9, 1.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black54,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_modal.name}'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_modal.phone}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                ),
              ]),

              EditTextForm(
                'Organization Name',
                businessProfile.organizationName,
                top: 18,
              ),
              EditTextForm(
                'Business Category',
                businessProfile.businessCategory,
              ),
              EditTextForm(
                'Description',
                businessProfile.description,
              ),

              GoogleLocation(businessLocation),

              //*******************************************

              /// Emails
              EditButton('Emails', bottom: 12),
              ...businessEmails
                  .map((e) => ListTile(
                        onTap: () => launch('mailto://$e'),
                        leading: Icon(
                          Icons.mail,
                          color: Colors.green,
                        ),
                        title: Text('$e'),
                      ))
                  .toList(),

              /// Contacts
              EditButton('Contacts', bottom: 12),
              ...businessContacts
                  .map((e) => ListTile(
                        onTap: () => launch('tel://${e.phone}'),
                        leading: Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                        title: Text('${e.phone}'),
                        trailing: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: Color(0xFF4FCE5D),
                          ),
                          onPressed: () => launch(
                              'https://wa.me/${e.phone.replaceAll('+', '')}'),
                        ),
                      ))
                  .toList(),

              /// Links
              EditButton('Links', bottom: 12),
              ...businessLinks
                  .map((e) => ListTile(
                        onTap: () async {
                          final String url = e.link ?? '';
                          await launch(
                              url.startsWith('http') ? url : 'http://$url');
                          print('url => $url');
                        },
                        leading: e.icon,
                        title: Text('${e.link}'),
                      ))
                  .toList(),

              /// Catalogue
              EditButton('Catalogue', bottom: 12),

              if (businessCatalogue.isNotEmpty)
                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  children: businessCatalogue
                      .map((src) => Container(
                          padding: EdgeInsets.all(3),
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context, PhotoViewer.page(src)),
                              child: Image.network(src, fit: BoxFit.fill))))
                      .toList(),
                ),

              // Additional Information
              EditButton(
                'Additional Information'.toUpperCase(),
                bottom: 12,
                color: Colors.transparent,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (businessGst.isNotEmpty && businessGst.visible) ...[
                EditButton('GST', bottom: 12),
                EditButton(
                  '${businessGst.number}',
                  bottom: 12,
                  color: Colors.transparent,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],

              EditButton('Our Bankers', bottom: 12),

              Container(
                padding: EdgeInsets.only(
                  bottom: 6,
                  right: 12,
                  left: 12,
                  top: 6,
                ),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(6)),
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(
                        () => businessBanks[index].isExpanded = !isExpanded);
                  },
                  children: businessBanks.map((bank) => bank.getUI).toList(),
                ),
              ),

              //*******************************************
            ]),
    );
  }
}
