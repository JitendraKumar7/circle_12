import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableText extends StatefulWidget {
  final Map<String, String> item;

  const ExpandableText(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12),
          constraints: BoxConstraints(
            minWidth: size.width,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
              //bottomLeft: Radius.circular(6),
              //bottomRight: Radius.circular(6),
            ),
            color: Colors.blue[100],
          ),
          child: Text(
            '${widget.item['header']}'.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(6),
          child: AnimatedSize(
            duration: Duration(milliseconds: 500),
            child: ConstrainedBox(
              constraints: isExpanded
                  ? BoxConstraints()
                  : BoxConstraints(maxHeight: 50.0),
              child: Html(data: '${widget.item['body']}'),
            ),
          ),
        ),
        isExpanded
            ? ConstrainedBox(
                constraints: BoxConstraints(),
              )
            : TextButton(
                child: Text('... Read more'),
                onPressed: () => setState(() => isExpanded = true),
              ),
      ],
    );
  }
}
