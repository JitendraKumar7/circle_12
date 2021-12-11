import 'package:circle/app/app.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/photo/photo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UpdateDocument? _reference;
  ProfileModal? _modal;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var db = FirestoreService();

      _modal = context.read<ProfileModal>();
      var _profile = await db.profile.doc(_modal!.id).get();

      _reference = UpdateDocument(_profile.reference, onUpdated: () async {
        setState(() => print('UpdateDocument'));
        _modal!.listeners();
      });

      if (mounted) setState(() => print('exists ${_profile.exists}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);
    if (_reference == null) return Center(child: CupertinoActivityIndicator());
    var businessKeywords = _modal!.businessKeywords;
    var businessCatalogue = _modal!.businessCatalogue;

    var businessEmails = _modal!.businessEmails;
    var businessContacts = _modal!.businessContacts;

    var businessLinks = _modal!.businessLinks;
    var businessBanks = _modal!.businessBanks;

    var businessGst = _modal!.businessGst;
    var businessProfile = _modal!.businessProfile;
    var businessLocation = _modal!.businessLocation;

    return ListView(children: [
      Stack(children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: (businessProfile.banner == null
                  ? AssetImage('assets/default/business.jpg')
                  : NetworkImage(businessProfile.banner!)) as ImageProvider,
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
                    '${_modal!.name}'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_modal!.phone}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ]),
          ),
        ),
        Container(
          height: 220,
          alignment: Alignment(0.9, 0.9),
          child: InkWell(
            child: CircleAvatar(
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              backgroundColor: Colors.orange,
            ),
            onTap: () async {
              businessProfile.id = _modal!.id;
              var _result = await Navigator.pushNamed(
                context,
                BUSINESS_PROFILE,
                arguments: businessProfile,
              );
              if (_result != null) {
                var params = _result as BusinessProfileModal;
                _reference!.updateProfile(params.toJson());
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: CupertinoSwitch(
            onChanged: (bool isActive) {
              businessProfile.isActive = isActive;
              _reference!.updateProfile(businessProfile.toJson());
            },
            value: businessProfile.isActive,
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

      GoogleLocation(businessLocation, onTap: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_LOCATION,
          arguments: businessLocation,
        );
        if (_result != null) {
          var params = _result as BusinessLocationModal;
          _reference!.updateLocation(params.toJson());
          _modal!.businessLocation = params;
        }
      }),

      //*******************************************

      /// Emails
      EditButton('Emails', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_EMAILS,
          arguments: businessEmails,
        );
        if (_result != null) {
          var params = _result as List<String>;
          _reference!.updateEmails(params);
        }
      }),
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
      EditButton('Contacts', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_CONTACTS,
          arguments: businessContacts,
        );
        if (_result != null) {
          var params = _result as List<BusinessContactModal>;
          _reference!.updateContacts(params);
        }
      }),
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
                  onPressed: () =>
                      launch('https://wa.me/${e.phone.replaceAll('+', '')}'),
                ),
              ))
          .toList(),

      /// Links
      EditButton('Links', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_LINKS,
          arguments: businessLinks,
        );
        if (_result != null) {
          var params = _result as List<BusinessLinkModal>;
          _reference!.updateLinks(params);
        }
      }),
      ...businessLinks
          .map((e) => ListTile(
                onTap: () async {
                  final String url = e.link ?? '';
                  await launch(url.startsWith('http') ? url : 'http://$url');
                  print('url => $url');
                },
                leading: e.icon,
                title: Text('${e.link}'),
              ))
          .toList(),

      /// Search Keywords
      EditButton('Search Keywords', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_KEYWORDS,
          arguments: businessKeywords,
        );
        if (_result != null) {
          var params = _result as List<String>;
          _reference!.updateKeywords(params);
        }
        _reference!.updateKeywords(businessKeywords);
      }),
      if (businessKeywords.isNotEmpty)
        Container(
          margin: EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Wrap(
            children: businessKeywords
                .map((keyword) => Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        keyword,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

      /// Catalogue
      EditButton('Catalogue', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_CATALOGUE,
          arguments: businessCatalogue,
        );
        if (_result != null) {
          var params = _result as List<String>;
          _reference!.updateCatalogue(params);
        }
      }),
      if (businessCatalogue.isNotEmpty)
        GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          children: businessCatalogue
              .map((src) => Container(
                  padding: EdgeInsets.all(3),
                  child: InkWell(
                      onTap: () => Navigator.push(context, PhotoViewer.page(src)),
                      child: Image.network(src, fit: BoxFit.fill))))
              .toList(),
        ),

      // Additional Information
      EditButton(
        'Additional Information'.toUpperCase(),
        bottom: 12,
        color: Colors.transparent,
        onPressed: () => messenger.showMaterialBanner(
          MaterialBanner(
              forceActionsBelow: true,
              content: Text(
                '\nDisplay of gst is optional . You may choose not  to mention .\n'
                '\nBut  display of gst gives additional security to customers about your business reliability\n'
                '\nA verify button  shall enable viewers to get your number verified from gst portal\n'
                '\n(This service is currently available only in India).\n'
                '\nIn period  you can  use this as gst search service\n',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('DISMISS'),
                  onPressed: () {
                    messenger.removeCurrentMaterialBanner();
                  },
                ),
              ]),
        ),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        icon: Icon(Icons.info_outline),
      ),

      EditButton('GST', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_GST,
          arguments: businessGst,
        );
        if (_result != null) {
          var params = _result as BusinessGstModal;
          _reference!.updateGst(params.toJson());
        }
      }),
      if (businessGst.isNotEmpty)
        EditButton(
          '${businessGst.number}',
          bottom: 12,
          color: Colors.transparent,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(
            businessGst.visible ? Icons.visibility : Icons.visibility_off,
            color: businessGst.visible ? Colors.green : Colors.grey,
          ),
        ),

      EditButton('Our Bankers', bottom: 12, onPressed: () async {
        var _result = await Navigator.pushNamed(
          context,
          BUSINESS_BANKS,
          arguments: businessBanks,
        );
        if (_result != null) {
          var params = _result as List<BusinessBankModal>;
          _reference!.updateBanks(params);
        }
      }),

      StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.only(
            bottom: 6,
            right: 12,
            left: 12,
            top: 6,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() => businessBanks[index].isExpanded = !isExpanded);
            },
            children: businessBanks.map((bank) => bank.getUI).toList(),
          ),
        );
      }),

      //*******************************************
    ]);
  }
}
