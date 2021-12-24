import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:circle/app/app.dart';

import 'modal/modal.dart';

//  successfully login
//
// resent otp on mobile
//
// notification page by timing... X
//
// broadcast toolbar icon top right
//
// share whatsapp ui with select any box
//
//
// circle delete..
//
// open web link to app

//https://pub.dev/packages/google_mobile_ads/example
//https://developers.google.com/admob/flutter/quick-start
//https://developers.google.com/ad-manager/mobile-ads-sdk/flutter/quick-start
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  // --------------------print(Firebase.app().options);
  // https://play.googleapis.com/play/log/timestamp
  // MD5: CA:44:DC:A5:64:21:17:CA:77:D7:82:94:83:34:8C:53
  // SHA1: 0A:B9:F6:EF:A2:86:8A:2E:CA:F3:64:6B:E8:6C:E4:6D:D0:E1:E4:BD
  // SHA-256: AA:9A:B9:74:F4:B7:3F:E1:C2:72:DA:80:3D:27:59:2C:A4:48:3D:7E:52:8C:32:04:F3:6E:EF:01:24:F1:BF:F7
  // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ // \\ //
  // MD5: 69:86:0A:DB:4F:7B:0D:3A:6A:4C:59:2A:56:59:2B:A1
  // SHA1: 3D:BC:51:3A:62:01:A4:C3:78:38:40:92:A8:56:08:FE:7C:E2:61:E7
  // SHA-256: 32:5C:A3:1C:65:8C:05:4C:72:FB:5C:01:84:BD:6B:6E:9B:69:33:AE:A5:66:AC:04:3E:2F:D1:E7:2C:E1:CC:4B

  // change account when verify mobile...
  // auto focus remove when read only...
  // number lock in profile mode...........
  // google map location error
  // xplore section fix error
  // profile not complete when create circle than update profile page.....

  // default admin chat
  // chat file image...
  //
  // request to join form or time show..
  // member list offer  count
  // offer list design
  //
  // page loader
  //
  // member
  //
  // business category search icon
  //
  // member count list offered location icon..
  //
  // circle remove

  // vendors, emergencies to view circle as a member
  // admin approval required member add member
  // offer view and comment

  final auth = await AuthenticationRepository();

  runApp(MultiProvider(child: App(repository: auth), providers: [
    ChangeNotifierProvider<ProfileModal>(create: (_) => ProfileModal()),
    FutureProvider<List<QueryDocumentSnapshot<CircleModal>>>(
      initialData: [],
      create: (context) async {
        var db = FirestoreService();
        var profile = context.read<ProfileModal>();
        print('FutureProviderProfileModal ${profile.id}');

        var circle = await db.circle
            .where('members', arrayContains: profile.phoneNumber)
            .get();

        print('FutureProviderProfileModal ${circle.size}');
        return circle.docs;
      },
    ),
  ]));
}

// Explore circle name background padding
// Search list error remove back button
// Member list profile business
//
// whatsapp message error
// internation api
