import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userPostCollection =
    FirebaseFirestore.instance.collection('user_posts');
final CollectionReference savedPostCollection =
    FirebaseFirestore.instance.collection('saved_posts');

/// User post class
class UserPost {
  String? email;
  UserPost({this.email});

  /// Saves post from the user
  Future<void> savePost(String? userEmail, String message) async {
    await userPostCollection.add({
      "message": message,
      "email": userEmail ?? '',
      "time": Timestamp.now(),
    });
  }

  /// Retrieves posts of an user based on their email
  Stream<QuerySnapshot<Object?>> getUserPostsByEmail() {
    return userPostCollection
        .where('email', isEqualTo: email)
        // .orderBy('time', descending: true)
        .snapshots();
  }

  /// Retrieves global posts
  Stream<QuerySnapshot<Object?>> getAllPosts() {
    return userPostCollection.orderBy('time', descending: true).snapshots();
  }

  // Delete an user post
  Future<bool> deletePost(String postId) async {
    try {
      await userPostCollection.doc(postId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Save for later class
class SaveUserPost {
  String? uid;
  SaveUserPost({
    this.uid,
  });

  /// Save a post for later
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

  // Unsave saved post for later
  Future<void> deletePost(String postId) async {
    await savedPostCollection.doc(uid).set(
      {
        "postIds": FieldValue.arrayRemove([postId])
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  /// Retrieve saved post ids based on user id
  Future<List> fetchPostIds() async {
    final docs = await savedPostCollection.doc(uid).get();
    if (docs.exists) {
      final postIds = docs.data() as Map<String, dynamic>;
      return postIds["postIds"] as List;
    } else {
      return [];
    }
  }

  /// Retrieve post data based on above post ids
  Stream<QuerySnapshot<Object?>> getSavedPostsByUser() async* {
    final savedPostIds = await fetchPostIds();
    if (savedPostIds.isEmpty) {
      yield* const Stream.empty();
      return;
    }
    yield* userPostCollection
        .where(FieldPath.documentId, whereIn: savedPostIds)
        .orderBy('time', descending: true)
        .snapshots();
  }
}
