import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat/modal/chat_user.dart';
import 'package:flutter_chat/modal/message_user.dart';

FirebaseDatabase _reference = FirebaseDatabase.instance;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();

  factory DatabaseService() {
    _reference.setPersistenceEnabled(true);
    return _instance;
  }

  DatabaseService._();

  DatabaseReference _database = _reference.reference();

  Future<void> pushMessages(
    String child,
    ChatUser user,
    MessageUser message,
  ) async {
    await _database.child('messages').child(child).push().set(message.toJson());

    user.timestamp = message.timestamp;
    user.message = message.message;
    await _database
        .child('chats')
        .child(user.currentUserId)
        .child(user.conversionUserId)
        .update(user.toUpdate());

    await _database
        .child('chats')
        .child(user.conversionUserId)
        .child(user.currentUserId)
        .update(user.toUpdate());
  }

  DatabaseReference chatsReference(String child) {
    return _database.child('chats').child(child);
  }

  DatabaseReference messagesReference(String child) {
    return _database.child('messages').child(child);
  }

  Future<ChatUser> getReferenceId(ChatUser user) async {
    var result = await _database
        .child('chats')
        .child(user.currentUserId)
        .child(user.conversionUserId)
        .get();
    if (result.exists) {
      return ChatUser.fromJson(result);
    }

    await _database
        .child('chats')
        .child(user.currentUserId)
        .child(user.conversionUserId)
        .set(user.currentJson());

    await _database
        .child('chats')
        .child(user.conversionUserId)
        .child(user.currentUserId)
        .set(user.conversionJson());
    return user;
  }
}
