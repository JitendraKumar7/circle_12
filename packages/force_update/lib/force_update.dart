library force_update;

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class CheckVersion {
  String? iOSId;
  String? androidId;
  BuildContext context;

  CheckVersion(
    this.context, {
    this.iOSId,
    this.androidId,
  });

  Future<PackageInfo> fromPlatform() async {
    return await PackageInfo.fromPlatform();
  }

  Future<String> getVersion() async {
    return (await fromPlatform()).version;
  }

  Future<AppVersionStatus> getVersionStatus() async {
    PackageInfo packageInfo = await fromPlatform();
    AppVersionStatus versionStatus =
        AppVersionStatus(localVersion: packageInfo.version);
    final platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.iOS:
        final id = iOSId ?? packageInfo.packageName;
        versionStatus = await iOSAtStoreVersion(id, versionStatus);
        break;
      case TargetPlatform.android:
        final id = androidId ?? packageInfo.packageName;
        versionStatus = await getAndroidAtStoreVersion(id, versionStatus);
        break;
      default:
        print('This platform is not yet supported by this package.');
    }

    List storeVersion = versionStatus.storeVersion!.split('.');
    List currentVersion = versionStatus.localVersion!.split('.');
    if (storeVersion.length < currentVersion.length) {
      int missValues = currentVersion.length - storeVersion.length;
      for (int i = 0; i < missValues; i++) {
        storeVersion.add(0);
      }
    }
    // version
    else if (storeVersion.length > currentVersion.length) {
      int missValues = storeVersion.length - currentVersion.length;
      for (int i = 0; i < missValues; i++) {
        currentVersion.add(0);
      }
    }

    for (int i = 0; i < storeVersion.length; i++) {
      if (int.parse(storeVersion[i]) > int.parse(currentVersion[i])) {
        versionStatus.canUpdate = true;
        return versionStatus;
      }
    }
    versionStatus.canUpdate = false;
    return versionStatus;
  }

  iOSAtStoreVersion(
      String appId
      /**app id in apple store not app bundle id*/,
      AppVersionStatus versionStatus) async {
    final response = await http
        .get(Uri.parse('http://itunes.apple.com/lookup?bundleId=$appId'));
    if (response.statusCode != 200) {
      print('The app with id: $appId is not found in app store');
      return null;
    }
    final jsonObj = jsonDecode(response.body);
    versionStatus.storeVersion = jsonObj['results'][0]['version'];
    versionStatus.appStoreUrl = jsonObj['results'][0]['trackViewUrl'];
    return versionStatus;
  }

  getAndroidAtStoreVersion(
      String applicationId
      /**application id, generally stay in build.gradle*/,
      AppVersionStatus versionStatus) async {
    final url = 'https://play.google.com/store/apps/details?id=$applicationId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print(
          'The app with application id: $applicationId is not found in play store');
      return null;
    }
    final document = html.parse(response.body);
    final elements = document.getElementsByClassName('hAyfc');
    final versionElement = elements.firstWhere(
      (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
    );
    versionStatus.storeVersion = versionElement.querySelector('.htlgb')!.text;
    versionStatus.appStoreUrl = url;
    return versionStatus;
  }

  void showUpdateDialog() async {
    String message = 'You can now update this app from store.';
    String titleText = 'Update Available';
    String updateText = 'Update Now';
    String dismissText = 'Later';

    Text title = Text(titleText);
    final content = Text(message);
    Text dismiss = Text(dismissText);
    final dismissAction = () => Navigator.pop(context);
    Text update = Text(updateText);
    final updateAction = () {
      OpenAppstore.launch(
        'com.konnect.my.circle',
        'id1563459732',
      );
      Navigator.pop(context);
    };
    final platform = Theme.of(context).platform;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return platform == TargetPlatform.iOS
            ? CupertinoAlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: dismiss,
                    onPressed: dismissAction,
                  ),
                  CupertinoDialogAction(
                    child: update,
                    onPressed: updateAction,
                  ),
                ],
              )
            : AlertDialog(
                title: title,
                content: content,
                actions: <Widget>[
                  TextButton(
                    child: dismiss,
                    onPressed: dismissAction,
                  ),
                  ElevatedButton(
                    child: update,
                    onPressed: updateAction,
                  ),
                ],
              );
      },
    );
  }
}

class OpenAppstore {
  static MethodChannel _channel = MethodChannel('flutter.moum.open_appstore');

  static Future<String> get platformVersion async {
    _channel = MethodChannel('flutter.moum.open_appstore');
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void launch(String androidApplicationId, String iOSAppId) async {
    _channel = MethodChannel('flutter.moum.open_appstore');
    await _channel.invokeMethod('openappstore', {
      'android_id': androidApplicationId,
      'ios_id': iOSAppId,
    });
  }
}

class AppVersionStatus {
  bool? canUpdate;
  String? localVersion;
  String? storeVersion;
  String? appStoreUrl;

  AppVersionStatus({
    this.canUpdate,
    this.storeVersion,
    required this.localVersion,
  });
}
