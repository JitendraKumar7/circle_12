import 'dart:io';

import 'package:circle/constant/constant.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

class ShareProfilePage extends StatefulWidget {
  const ShareProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShareProfileState();
}

class _ShareProfileState extends State<ShareProfilePage> {
  var _controller = ScreenshotController();
  var _modal = ProfileModal();

  List<Map<String, dynamic>> _selectable = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _modal = context.read<ProfileModal>();
      _getProfile();
    });
  }

  void _addValue(String? title) {
    _selectable.add({
      'title': title,
      'isSelect': false,
    });
  }

  Future<void> _getProfile() async {
    _modal.businessEmails.forEach((e) => _addValue(e));
    _modal.businessContacts.forEach((e) => _addValue(e.phone));

    _modal.businessBanks.forEach(
      (e) => _addValue(''
          '\n*${e.name}*'
          '\n*${e.holder}*'
          '\nIFSC - ${e.ifsc}'
          '\nAcc. No. - ${e.number}'
          '\n'),
    );

    if (_modal.businessGst.visible) {
      var number = _modal.businessGst.number;
      _addValue('*GSTIN - $number*');
    }

    if (!_modal.businessLocation.isEmpty) {
      _addValue('\n*I am on Google map*\n'
          '\n${_modal.businessLocation.navigation}');
    }

    setState(() => debugPrint('profile done'));
  }

  Future<void> _takeScreenshot(bool isWhatsApp) async {
    await Permission.storage.request();
    showCenterLoader(context, 9);

    String shareValue =
        '*${_modal.getOrganizationName?.toUpperCase() ?? ''}*\n\n';
    shareValue += '*${_modal.getBusinessCategory ?? ''}* \n\n';
    shareValue += '*Location*\n\n${_modal.businessLocation.addressLine ?? ''}';
    shareValue += '\n\n *Contact*';

    _selectable
        .forEach((e) => e['isSelect'] ? shareValue += '\n${e['title']}' : '');
    shareValue +=
        '\n\nTo create a similar business profile download *CircleApp* now';
    shareValue += '\n\non iOS\n $APPLE_URL\n\n on android\n $ANDROID_URL';

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/business_profile.png';

    await _controller.capture(delay: Duration(seconds: 9)).then((image) async {
      print('Share Business Card ${image != null}');
      if (image != null) {
        final imagePath = await File(path).create();
        await imagePath.writeAsBytes(image);
        if (isWhatsApp) {
          Navigator.push(
              context,
              ShareOnWhatsApp.page(
                path: imagePath.path,
                message: shareValue,
              ));
        } else
          await Share.shareFiles(
            [imagePath.path],
            text: shareValue,
            subject: 'Share Business Card',
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var businessProfile = _modal.businessProfile;
    return Column(children: <Widget>[
      Screenshot(
        controller: _controller,
        child: Container(
          width: size.width,
          height: size.width / 1.5,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black87,
            image: DecorationImage(
              image: (businessProfile.banner == null
                  ? AssetImage('assets/default/business.jpg')
                  : NetworkImage(businessProfile.banner!)) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: size.width,
            color: Colors.black54,
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _modal.name ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _modal.phone,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(18),
            children: [
              RichText(
                text: TextSpan(
                  text: businessProfile.organizationName ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\n',
                    ),
                    TextSpan(
                      text: businessProfile.businessCategory ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Location',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 18),
              Text(
                _modal.businessLocation.addressLine ?? '',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 18),
              RichText(
                text: TextSpan(
                  text: 'Contact',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._selectable
                  .map((value) => CheckboxListTile(
                        title: Text(
                          value['title'],
                          style: TextStyle(color: Colors.black54),
                        ),
                        value: value['isSelect'],
                        onChanged: (newValue) => setState(() {
                          //print('isSelect => $newValue');
                          _selectable.firstWhere((element) =>
                              element['title'] ==
                              value['title'])['isSelect'] = newValue;
                        }),
                        controlAffinity: ListTileControlAffinity.leading,
                      ))
                  .toList(),
              SizedBox(height: 18),
            ]),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        /*IconButton(
            onPressed: () => _takeScreenshot(true),
            icon: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Color(0xFF4FCE5D),
            ))*/

        TextButton.icon(
          icon: FaIcon(
            FontAwesomeIcons.whatsapp,
            color: Color(0xFF4FCE5D),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 18),
          ),
          label: Text('Share Whatsapp'),
          onPressed: () => _takeScreenshot(true),
        ),
        TextButton.icon(
          icon: FaIcon(
            FontAwesomeIcons.share,
            color: Color(0xFF4FCE5D),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(right: 18),
          ),
          label: Text('Share More'),
          onPressed: () => _takeScreenshot(false),
        ),
      ]),
    ]);
  }
}

class ShareOnWhatsApp extends StatelessWidget {
  final dialCode = TextEditingController();
  final controller = TextEditingController();

  final String filePath;
  final String message;

  static Route<String> page({
    required String message,
    required String path,
  }) {
    return MaterialPageRoute(
      builder: (_) => ShareOnWhatsApp(
        filePath: path,
        message: message,
      ),
    );
  }

  ShareOnWhatsApp({
    Key? key,
    required this.message,
    required this.filePath,
  }) : super(key: key);

  _onPressed(Package package) async {
    var contact = dialCode.text + controller.text;
    var whatsapp = contact.replaceAll('+', '');

    print('whatsapp => $whatsapp');
    print('package => $package');
    if (controller.text.isNotEmpty) {
      await WhatsappShare.shareFile(
        text: message,
        phone: whatsapp,
        package: package,
        filePath: [filePath],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var package = Package.whatsapp;
    dialCode.text = '+91';
    return Scaffold(
      appBar: AppBar(title: Text('Share on whatsapp'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            helperText: '',
            filled: true,
            fillColor: Colors.blue[50],
            prefixIcon: CountryCodePicker(
              onChanged: (code) => dialCode.text = code.dialCode ?? '+91',
              onInit: (code) => dialCode.text = code?.dialCode ?? '+91',
              initialSelection: 'IN',
              showFlag: false,
              showFlagDialog: true,
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
            ),
          ),
        ),
        SizedBox(height: 48),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.all(18),
          child: Column(children: [
            Text.rich(
              TextSpan(
                  text: 'if contact is not in your phonebook than ',
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        child: Text(
                          'click here',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blue,
                          ),
                        ),
                        onTap: () async {
                          var contact = dialCode.text + controller.text;
                          var whatsapp = contact.replaceAll('+', '');

                          print('whatsapp => $whatsapp, package => $package');
                          if (controller.text.isNotEmpty)
                            launch('https://wa.me/$whatsapp');
                        },
                      ),
                    ),
                    TextSpan(text: ' after that share on '),
                  ]),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 30),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 42,
                    onPressed: () => _onPressed(Package.whatsapp),
                    icon: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Color(0xFF4FCE5D),
                    ),
                  ),
                  IconButton(
                    iconSize: 36,
                    onPressed: () => _onPressed(Package.businessWhatsapp),
                    icon: Image.asset('assets/whatsapp_business.png'),
                  ),
                ]),
          ]),
        ),
      ]),
    );
  }
}
