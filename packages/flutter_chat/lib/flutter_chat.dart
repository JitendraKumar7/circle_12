library flutter_chat;

import 'package:flutter/material.dart';
import 'package:flutter_chat/service/db_service.dart';
import 'package:flutter_chat/view/chat/chat_screen.dart';

import 'modal/chat_user.dart';
import 'modal/message_user.dart';

Future<bool> loadConversion(
  BuildContext context,
  String? currentUserId,
  String? conversionUserId,
  String? conversionUserName,
) async {
  ChatUser _user = ChatUser(currentUserId, conversionUserId);
  var profile = await DatabaseService().getReferenceId(_user);

  profile.name = conversionUserName;
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => Conversation(profile)),
  );
  return true;
}

Future<bool> firstConversion(
  String? userId,
  String? userName,
) async {
  var isAdmin = '6rqmADWLmESuDe9scNfC32n2Q1W2';
  var message =
      'Hello ${userName?.toUpperCase()} \n\nThanks for choosing CircleApp.\n'
      'This is a valuable opportunity to build a community of real business.\n'
      'Sell & buy from trusted, verified business.\n'
      'Maximize gain, promote your business among circles of friends, family & associates.\n'
      'Bargain maximum, get best deals when buying from referred sellers in app.\n'
      'Make your business profile searchable by adding business related keywords.\n'
      'Create & post offers with search enhancer keywords in different categories.\n'
      'Share business profile as your business card with clients suppliers & customers.\n\n'
      'Feedback is appreciated.\n\n'
      'Support mail is welcome at\n'
      'support@konnectmycircle.com';

  var _service = DatabaseService();
  var _chatUser = ChatUser(userId, isAdmin);
  var _messageUser = MessageUser(message, isAdmin);

  var _profile = await _service.getReferenceId(_chatUser);
  _service.pushMessages(_profile.referenceId, _profile, _messageUser);

  return true;
}
