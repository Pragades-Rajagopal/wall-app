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

class SavedUserPost {
  String? uid;
  SavedUserPost({
    this.uid,
  });

  Future<void> savePost(String postId) async {
    await FirebaseFirestore.instance
        .collection('saved_posts')
        .doc(uid)
        .set({"postIds": postId}, SetOptions(merge: true));
  }
}
