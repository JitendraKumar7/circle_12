import 'package:circle/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/view/view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    return ChatScreen(profile.id ?? '');
  }
}
