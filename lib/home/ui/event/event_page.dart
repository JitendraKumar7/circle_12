import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Image.asset(
      'assets/empty/event.jpg',
      fit: BoxFit.fitWidth,
      width: _size.width,
    );
  }

}