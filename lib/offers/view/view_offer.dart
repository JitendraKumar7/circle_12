import 'package:circle/app/app.dart';
import 'package:flutter/material.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/home/ui/offer/view/view.dart';
import 'package:circle/widget/future/widget_builder.dart';

class ViewOfferPage extends StatefulWidget {
  @override
  State<ViewOfferPage> createState() => _ViewOfferState();
}

class _ViewOfferState extends State<ViewOfferPage> {
  late QueryDocumentSnapshot<OfferModal> snapshot;

  var db = FirestoreService();
  late ProfileModal profile;

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    snapshot = args as QueryDocumentSnapshot<OfferModal>;
    profile = context.read<ProfileModal>();

    var offerModal = snapshot.data();

    var views = offerModal.views;
    if (!views.any((id) => id == profile.id)) {
      views.add(profile.id ?? '');
      snapshot.reference.update({'views': views});
    }

    return Scaffold(
      appBar: AppBar(title: Text('OfferView')),
      body: Column(children: [
        Expanded(
          child: ListView(children: [
            OfferChildView(
              snapshot,
              isView: true,
              showHeaders: false,
            ),
            StreamBuilder(
              stream: db.offerComment(snapshot.reference).snapshots(),
              builder: (_, AsyncSnapshot<QuerySnapshot<OfferComment>> data) {
                return Column(
                    children: (data.data?.docs ?? []).map((e) {
                  var comment = e.data();
                  return Column(children: [
                    ListTile(
                      title: Text(comment.userName ?? 'name'),
                      subtitle: Row(children: [
                        Expanded(
                          child: Text(comment.comment ?? 'comment'),
                        ),
                        Text(comment.getFormatDate()),
                      ]),
                    ),
                    ...comment.reply.map((e) => Text(e)).toList(),
                    if (profile.id == offerModal.createdBy ||
                        profile.id == comment.userId)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 99,
                                  minLines: 1,
                                  controller: comment.controller,
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Reply...',
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    var value = comment.controller.text;
                                    if (value.isNotEmpty) {
                                      var reply = comment.reply..add(value);
                                      e.reference.update({'reply': reply});
                                    }
                                  },
                                ),
                              ),
                            ]),
                      ),
                    Divider(),
                  ]);
                }).toList());
              },
            ),
          ]),
        ),
        if (profile.id != offerModal.createdBy)
          FutureWidgetBuilder(
              future: db.profile.doc(offerModal.createdBy).get(),
              builder: (DocumentSnapshot<ProfileModal>? profile) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  color: Colors.blue[100],
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 99,
                            minLines: 1,
                            controller: controller,
                            onSubmitted: (String value) =>
                                _commentSubmit(profile),
                            decoration:
                                InputDecoration.collapsed(hintText: 'Write...'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () => _commentSubmit(profile),
                          ),
                        ),
                      ]),
                );
              }),
      ]),
    );
  }

  _commentSubmit(DocumentSnapshot<ProfileModal>? profile) async {
    var comments = snapshot.data().comments;
    if (controller.text.isNotEmpty) {
      var comment = OfferComment(
        userName: profile?.get('name'),
        userId: profile?.id,
        comment: controller.text,
      );
      controller.text = '';
      await db.offerComment(snapshot.reference).add(comment);
      if (!comments.any((id) => id == profile?.id)) {
        comments.add(profile?.id ?? '');
        snapshot.reference.update({'comments': comments});
      }
    }
  }
}
