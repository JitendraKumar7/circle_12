import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/service/picker/image_picker.dart';
import 'package:flutter_chat/service/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chat/modal/chat_user.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_chat/modal/message_user.dart';
import 'package:flutter_chat/service/db_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// - CupertinoActivityIndicator()
class ChatScreen extends StatelessWidget {
  final DatabaseService _service = DatabaseService();
  final String referenceId;

  ChatScreen(
    this.referenceId, {
    Key? key,
  }) : super(key: key);

  String fromTimestamp(timestamp) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    var difference = DateTime(dateTime.year, dateTime.month, dateTime.day);

    var newPattern =
        today.difference(difference).inDays == 0 ? 'hh:mm a' : 'dd MMM yyyy';
    return DateFormat(newPattern).format(dateTime);
  }

  Widget loadProfile(ChatUser chatUser) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Profile')
          .doc(chatUser.conversionUserId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        Widget leading = Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: CupertinoActivityIndicator(),
        );

        if (snapshot.hasData) {
          chatUser.name = snapshot.data!.get('name');
          chatUser.profile = snapshot.data!.get('profile');

          leading = CircleAvatar(
            backgroundImage: (chatUser.profile != null
                ? NetworkImage(chatUser.profile)
                : AssetImage(
                    'assets/default/user.jpg',
                  )) as ImageProvider,
          );
        }

        return Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: leading,
            onTap: () async => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Conversation(chatUser)),
            ),
            title: Text(
                '${chatUser.name ?? chatUser.currentUserId}'.toUpperCase()),
            subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${chatUser.message ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    fromTimestamp(chatUser.timestamp),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
          Divider(),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      reverse: true,
      shrinkWrap: true,
      query: _service.chatsReference(referenceId),
      padding: const EdgeInsets.all(8.0),
      defaultChild: Center(child: CupertinoActivityIndicator()),
      /*sort: (a, b) => b.value['timestamp'].compareTo(a.value['timestamp']),*/
      itemBuilder:
          (_, DataSnapshot data, Animation<double> animation, int index) {
        var chatUser = ChatUser.fromJson(data);

        return SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.decelerate,
          ),
          child: loadProfile(chatUser),
        );
      },
    );
  }
}

class Conversation extends StatefulWidget {
  final ChatUser profile;

  const Conversation(
    this.profile, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  bool _isComposingMessage = false;
  final _textEditingController = TextEditingController();

  DatabaseService _service = DatabaseService();
  String path = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    path = widget.profile.referenceId;
  }

  var styleMe = BubbleStyle(
    nip: BubbleNip.leftTop,
    color: Colors.white,
    elevation: 1 * 2.0,
    margin: BubbleEdges.only(top: 8.0, right: 50.0),
    alignment: Alignment.topLeft,
  );

  var styleSomebody = BubbleStyle(
    nip: BubbleNip.rightTop,
    color: Colors.blue[100],
    elevation: 1 * 2.0,
    margin: BubbleEdges.only(top: 8.0, left: 50.0),
    alignment: Alignment.topRight,
  );

  Widget _buildTextComposer() {
    var secondary = Theme.of(context).colorScheme.secondary;
    return IconTheme(
      data: IconThemeData(
        color:
            _isComposingMessage ? secondary : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: secondary,
                ),
                onPressed: () async {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                child: TextButton(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.attach_file,
                                            color: secondary,
                                          ),
                                          Text(' File '),
                                        ]),
                                    onPressed: () async {
                                      var file =
                                          await ImageCropPicker().pickFile();
                                      if (file != null) {
                                        var filePath = await StorageService()
                                            .uploadImage(file: file);
                                        var id = widget.profile.currentUserId;
                                        var messageUser = MessageUser(null, id);
                                        messageUser.fileUrl = filePath;
                                        _service.pushMessages(
                                          path,
                                          widget.profile,
                                          messageUser,
                                        );
                                      }
                                      Navigator.pop(context);
                                    }),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.0),
                                child: TextButton(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.photo_camera,
                                          color: secondary,
                                        ),
                                        Text(' Image '),
                                      ],
                                    ),
                                    onPressed: () async {
                                      var file = await ImageCropPicker()
                                          .pickImage(isCamera: false);
                                      if (file != null) {
                                        var imagePath = await StorageService()
                                            .uploadImage(file: file);
                                        var id = widget.profile.currentUserId;
                                        var messageUser = MessageUser(null, id);
                                        messageUser.imageUrl = imagePath;
                                        _service.pushMessages(
                                          path,
                                          widget.profile,
                                          messageUser,
                                        );
                                      }
                                      Navigator.pop(context);
                                    }),
                              ),
                            ]);
                      });
                }),
          ),
          Flexible(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 99,
              minLines: 1,
              controller: _textEditingController,
              onChanged: (String messageText) {
                setState(() {
                  _isComposingMessage = messageText.length > 0;
                });
              },
              onSubmitted: _textMessageSubmitted,
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme.of(context).platform == TargetPlatform.iOS
                ? getIOSSendButton()
                : getDefaultSendButton(),
          ),
        ]),
      ),
    );
  }

  String fromTimestamp(timestamp) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    var difference = DateTime(dateTime.year, dateTime.month, dateTime.day);

    var newPattern = today.difference(difference).inDays == 0
        ? 'hh:mm a'
        : 'dd/MM/yyyy hh:mm a';
    return DateFormat(newPattern).format(dateTime);
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  CupertinoButton getIOSSendButton() {
    return CupertinoButton(
      child: Text('Send'),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.profile.name}')),
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: FirebaseAnimatedList(
              query: _service.messagesReference(path),
              defaultChild: Center(child: CupertinoActivityIndicator()),
              padding: const EdgeInsets.all(9),
              reverse: true,
              sort: (a, b) => (b.key ?? '1').compareTo((a.key ?? '0')),
              itemBuilder: (_, DataSnapshot data, __, ___) {
                var messageUser = MessageUser.fromJson(data);
                messageUser.currentUserId = widget.profile.currentUserId;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Bubble(
                    style: messageUser.isSender ? styleSomebody : styleMe,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          snapshot(messageUser),
                          Text(
                            fromTimestamp(messageUser.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Times New Roman',
                            ),
                          ),
                        ]),
                  ),
                );
              },
            ),
          ),
        ),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    if (text.trim().isEmpty) {
      return;
    }
    var id = widget.profile.currentUserId;
    MessageUser messageUser = MessageUser(text, id);
    _service.pushMessages(path, widget.profile, messageUser);
  }

  Widget snapshot(MessageUser message) {
    if (message.imageUrl != null) {
      return Stack(children: [
        Container(
          width: 250.0,
          height: 120.0,
          margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scaffold(
                          appBar: AppBar(title: Text('View')),
                          body: Center(
                            child: CachedNetworkImage(
                              imageUrl: message.imageUrl,
                              placeholder: (context, url) =>
                                  Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ))),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: message.imageUrl,
              placeholder: (context, url) =>
                  Center(child: CupertinoActivityIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 250.0,
            ),
          ),
        ),
        message.isSender
            ? Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 12,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _service
                        .messagesReference(path)
                        .child(message.key)
                        .remove();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Remove success'),
                      ),
                    );
                  },
                ),
              )
            : SizedBox(),
      ]);
    }
    if (message.fileUrl != null) {
      var fileUrl = message.fileUrl;
      return Stack(
        children: [
          Container(
            width: 250.0,
            height: 120.0,
            margin: const EdgeInsets.only(top: 5.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                child: FutureBuilder<File>(
                  future: DefaultCacheManager().getSingleFile(fileUrl),
                  builder: (context, snapshot) {
                    print('path ${snapshot.data?.path}');
                    return snapshot.hasData
                        ? Stack(children: [
                            PDFView(filePath: snapshot.data?.path),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PdfViewerFromUrl(fileUrl),
                                  ),
                                );
                              },
                              child: Container(
                                width: 250.0,
                                height: 450.0,
                                color: Colors.transparent,
                              ),
                            ),
                          ])
                        : Center(child: CupertinoActivityIndicator());
                  },
                ),
              ),
              Text(
                message.message ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ]),
          ),
          message.isSender
              ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 12,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _service
                          .messagesReference(path)
                          .child(message.key)
                          .remove();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Remove success'),
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(),
        ],
      );
    }
    if (message.message != null) {
      return Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: LinkifyText(
          message.message,
          onTap: (link) async {
            if (link.value != null) if (await canLaunch(link.value!)) {
              await launch(link.value!);
            }
          },
          maxLines: 99,
          overflow: TextOverflow.ellipsis,
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.normal,
          ),
          linkStyle: TextStyle(
            fontSize: 18,
            color: message.isSender ? Colors.teal : Colors.blue[300],
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Icon(Icons.update),
    );
  }
}

class InAppWebViewApp extends StatelessWidget {
  final String url;

  const InAppWebViewApp(
    this.url, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var base = 'https://docs.google.com/viewer';
    String _url = '$base?url=${url}&embedded=true';
    print('Download url $_url');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(_url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(),
          ),
        ),
      ),
    );
  }
}

class PdfViewerFromUrl extends StatelessWidget {
  final String fileUrl;

  const PdfViewerFromUrl(
    this.fileUrl, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<File>(
          future: DefaultCacheManager().getSingleFile(fileUrl),
          builder: (context, snapshot) {
            print('path ${snapshot.data?.path}');
            return snapshot.hasData
                ? PDFView(filePath: snapshot.data?.path)
                : Center(child: CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }
}
