import 'package:circle/modal/modal.dart';

const String APPLE_URL = 'https://apple.co/3FULvpI';
const String ANDROID_URL = 'https://bit.ly/3rxFlUM';
const String SUPPORT_MAIL = 'mailto:support@konnectmycircle.com';

const String SHARE_APP_MESSAGE = '*Hey*,\n\n'
    'Advertise your business & profession among friends, family, neighbours & associates.\n'
    'Why? Because customers are more sure to buy if they know the seller.\n\n'
    'OR\n\n'
    'Are you searching for a product or service then try first with your friends, family, neighbours, associates or any person they give reference of.\n\n'
    '*How*\n\n'
    'Get connected with multiple referred sellers & businesses in this app\n\n'
    'Start free online business promotion among friends, family, neighbours  & business circles\n\n'
    'watch video - https://youtu.be/ulFkotX2o0Q\n\n'
    'logon -www.konnectmycircle.com\n\n'
    'Download *CIRCLE APP*\n\n\n'
    '*on Ios* \n$APPLE_URL\n\n'
    '*on Android* \n$ANDROID_URL';

String getCircleShare(String? id, String? name) {
  return 'Hi,\n'
      'welcome  to the new way of  business  networking. '
      'I would like you to connect with  multiple  contacts in my *${name?.toUpperCase()}* circle. '
      '\nTo start  click the link below and open it in the app'
      '\n\nhttps://konnectmycircle.com/?circle=$id';
}

String getProfileShare(ContactModal contact, String? circle) {
  return 'Hi,\n'
      'welcome to the new way of business networking. I would like  you to connect with '
      '*${contact.name?.toUpperCase()}* of my  *${circle?.toUpperCase()}* circle in *${contact.category?.toUpperCase()}* business category.'
      '\nTo  start  click  the link below and open it in the app.'
      '\n\nhttps://konnectmycircle.com/?profile=${contact.referenceId}';
}
