import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum FormStatus {
  SUBMITTING,
  SUCCESS,
  INVALID,
  VALID,
}

class BaseModal {
  String documentId = Uuid().v1();

  int timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

  String getFormatDate() {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['documentId'] = documentId;
    json['timestamp'] = timestamp;
    return json;
  }

  String fromTimestamp(timestamp) {
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var difference = DateTime(dateTime.year, dateTime.month, dateTime.day);

    var newPattern =
        today.difference(difference).inDays == 0 ? 'hh:mm a' : 'dd MMM yyyy';

    return DateFormat(newPattern).format(dateTime);
  }

  @override
  String toString() => jsonEncode(toJson());
}
