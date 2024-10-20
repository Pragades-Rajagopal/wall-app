import 'package:cloud_firestore/cloud_firestore.dart';

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
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  return '$month $day, $hour:$minute';
}
