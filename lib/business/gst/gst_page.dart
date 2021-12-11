import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GstPage extends StatefulWidget {
  @override
  State<GstPage> createState() => _GstPageState();
}

class _GstPageState extends State<GstPage> {
  BusinessGstModal businessGst = BusinessGstModal();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessGst = args as BusinessGstModal;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GSTIN')),
      body: Column(children: [
        EditTextForm(
          'GSTIN',
          businessGst.number,
          keyboardType: TextInputType.text,
          onChanged: (value) => businessGst.number = value.toUpperCase(),
          readOnly: false,
          top: 18,
        ),
        Expanded(
            child: Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(right: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(businessGst.visible ? 'public' : 'private'),
              SizedBox(width: 18),
              CupertinoSwitch(
                onChanged: (bool visible) =>
                    setState(() => businessGst.visible = visible),
                value: businessGst.visible,
              ),
            ],
          ),
        )),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, businessGst),
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 18),
              padding: EdgeInsets.all(12),
                minimumSize: Size(180, 45),
                primary: Colors.blue[300]),
            child: Text('UPDATE'),
          ),
        )
      ]),
    );
  }
}
