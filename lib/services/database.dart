import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  Future<void> savePost(String? userEmail, String message) async {
    await FirebaseFirestore.instance.collection('user_posts').add({
      "message": message,
      "email": userEmail ?? '',
      "time": Timestamp.now(),
    });
  }
}
