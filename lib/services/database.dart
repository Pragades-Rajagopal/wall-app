import 'package:cloud_firestore/cloud_firestore.dart';

class UserPost {
  final CollectionReference userPostCollection =
      FirebaseFirestore.instance.collection('user_posts');
  Future<void> savePost(String? userEmail, String message) async {
    await userPostCollection.add({
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

  final CollectionReference savedPostCollection =
      FirebaseFirestore.instance.collection('saved_posts');

  Future<void> savePost(String postId) async {
    await savedPostCollection.doc(uid).set(
      {
        "postIds": FieldValue.arrayUnion([postId])
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}
