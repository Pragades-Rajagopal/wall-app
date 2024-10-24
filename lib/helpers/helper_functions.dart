import 'package:cloud_firestore/cloud_firestore.dart';

/// Converts Firestore Timestamp to `Oct 24, 18:15` format
String getFormattedTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  int day = dateTime.day;
  String month = months[dateTime.month];
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  return '$month $day, $hour:$minute';
}
