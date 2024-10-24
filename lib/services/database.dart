import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
final CollectionReference userPostCollection =
    FirebaseFirestore.instance.collection('user_posts');
final CollectionReference savedPostCollection =
    FirebaseFirestore.instance.collection('saved_posts');
final CollectionReference commentCollection =
    FirebaseFirestore.instance.collection('comments');

/// User profile class
class Users {
  String? email;
  Users({this.email});

  /// Get user info by email
  Stream<DocumentSnapshot> getInfo() {
    return userCollection.doc(email).snapshots();
  }

  /// Update user info
  Future<void> updateInfo(String field, String value) async {
    await userCollection.doc(email).update({field: value});
  }

  /// Get all username
  Stream<QuerySnapshot<Object?>> getAllUsernames() {
    return userCollection.snapshots();
  }

  /// Gets username for the email
  Future<String> getUsername() async {
    final userInfo = await userCollection.doc(email).get();
    if (userInfo.exists) {
      final username = userInfo.data() as Map<String, dynamic>;
      return username["username"] as String;
    } else {
      return email!;
    }
  }
}

/// User post class
class UserPost {
  String? email;
  UserPost({this.email});

  /// Saves post from the user
  Future<void> savePost(String? username, String message) async {
    await userPostCollection.add({
      "message": message,
      "email": email ?? '',
      "username": username,
      "time": Timestamp.now(),
      "likes": [],
    });
  }

  /// Retrieves posts of an user based on their email
  Stream<QuerySnapshot<Object?>> getUserPostsByEmail() {
    return userPostCollection
        .where('email', isEqualTo: email)
        .orderBy('time', descending: true)
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

  /// Like an user post
  void likePost(String postId, bool isLiked) {
    DocumentReference docRef = userPostCollection.doc(postId);
    if (isLiked) {
      docRef.update({
        "likes": FieldValue.arrayUnion([email])
      });
    } else {
      docRef.update({
        "likes": FieldValue.arrayRemove([email])
      });
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

/// Comment for post
class Comment {
  String postId;
  Comment(this.postId);

  /// Add comment to a post
  Future<void> addComment(String comment, String commentedBy) async {
    await userPostCollection.doc(postId).collection('comments').add({
      "comment": comment,
      "commentedBy": commentedBy,
      "commentedAt": Timestamp.now(),
    });
  }

  /// Get comments for a post
  Stream<QuerySnapshot<Object?>> getCommentsForPost() {
    return userPostCollection
        .doc(postId)
        .collection('comments')
        .orderBy('commentedAt', descending: true)
        .snapshots();
  }
}
