import 'package:circle/modal/modal.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendWhatsAppMessage(String? phoneNumber, String message) {
  var phone = phoneNumber?.replaceAll('+', '');
  var url = 'https://messageapi.in/MessagingAPI/sendMessage.php?'
      'LoginId=9717080648&password=qwerty12&mobile_number=$phone&message=$message';
  return http.get(Uri.parse(url));
}

// https://messageapi.in/MessagingAPI/sendMessage.php?LoginId=9717080648&password=qwerty12&mobile_number=919654431845&message=Hii

// offer view single list and circle
//
// forgot password
//
// add member or add circle multi use..
//
// whats app template...
//
// business category
//
// offer and notification counter....

Future<void> sentOtp(ProfileModal profile, otp) async {
  var uri = Uri.parse('http://sms.sunstechit.com/app/smsapi/index.php');
  var sms = 'Dear ${profile.name}, your mobile verification code is $otp, '
      'for CIRCLE APP FOR NETWORKING';

  var message = 'Dear *${profile.name}*\n'
      'your verification code to sign up in circle app is *$otp*.\n'
      'How to use the App for Business promotion.\n'
      '1. Sign up in the app.\n'
      '2. Update  business profile.\n'
      '3. Add business keywords in the profile.\n'
      '4. Start a circle - add friends, family and social contacts.\n'
      '5. View businesses in other circles.\n'
      '6. Search for products and services.\n'
      '7. Get circle admin  referred sellers list.\n'
      '8. Enjoy buying from these trusted vendors.\n'
      'https://konnectmycircle.com';

  sendWhatsAppMessage(profile.phone, message);
  if (profile.countryCode == '+91') {
    var body = <String, String>{
      'template_id': '1207161718630433560',
      'key': '55E19BF769A898',
      'campaign': '0',
      'routeid': '13',
      'type': 'text',
      'senderid': 'KMCOTP',
      'contacts': '${profile.phoneNumber}',
      'msg': sms,
    };
    var _response = await http.post(uri, body: body);
    print({'body : $body', '_response : ${_response.body}'});
  }
  // international
  else {
    var url = 'https://api.authkey.io/request?authkey=274fe0c2c29ec224'
        '&country_code=${profile.countryCode?.replaceAll('+', '')}'
        '&mobile=${profile.phoneNumber}&sender=KMCOTP'
        '&sms=$sms';

    var _response = await http.get(Uri.parse(url));
    print({'international : ${_response.body}'});
  }
}
