import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/common.dart';
import 'package:wall_app/components/wall_post.dart';
import 'package:wall_app/services/database.dart';

class MyStreamBuilder extends StatefulWidget {
  final Stream<QuerySnapshot<Object?>> stream;
  final String noDataMessage;
  final bool isDismissableAction;
  final String dismissAction;
  const MyStreamBuilder({
    super.key,
    required this.stream,
    required this.noDataMessage,
    this.isDismissableAction = false,
    this.dismissAction = 'saveUserPost',
  });

  @override
  State<MyStreamBuilder> createState() => _MyStreamBuilderState();
}

class _MyStreamBuilderState extends State<MyStreamBuilder> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Widget? dismissableBg;

  Future<void> saveUserPost(String postId) async {
    await SaveUserPost(uid: currentUser?.uid).savePost(postId);
    if (mounted) {
      showSnackBar(context, 'POST SAVED', duration: 1);
    }
  }

  Future<void> deleteSavedUserPost(String postId) async {
    await SaveUserPost(uid: currentUser?.uid).deletePost(postId);
    if (mounted) {
      showSnackBar(context, 'POST UNSAVED', duration: 1);
    }
  }

  Future<void> deleteUserPost(String postId) async {
    final res = await UserPost().deletePost(postId);
    if (res && mounted) {
      showSnackBar(context, 'POST DELETED', duration: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dismissAction == 'saveUserPost') {
      dismissableBg = dismissableBackground(
        Colors.black38,
        Icons.bookmark,
      );
    } else if (widget.dismissAction == 'deleteUserPost') {
      dismissableBg = dismissableBackground(
        Colors.red,
        Icons.delete,
      );
    } else if (widget.dismissAction == 'unsaveSavedPost') {
      dismissableBg = dismissableBackground(
        Colors.black26,
        Icons.bookmark_remove,
      );
    }

    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.surfaceBright,
              strokeWidth: 6.0,
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong!\nTry again after sometime.',
              textAlign: TextAlign.center,
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];
              if (widget.isDismissableAction) {
                return Dismissible(
                  key: Key(post["message"]),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (_) async {
                    if (widget.dismissAction == 'saveUserPost') {
                      saveUserPost(post.id);
                    } else if (widget.dismissAction == 'deleteUserPost') {
                      deleteUserPost(post.id);
                      return true;
                    } else if (widget.dismissAction == 'unsaveSavedPost') {
                      deleteSavedUserPost(post.id);
                      return true;
                    }
                    return false;
                  },
                  background: dismissableBg,
                  child: WallPost(
                    message: post["message"],
                    user: post["email"],
                    time: post["time"],
                    postId: post.id,
                    likes: List<String>.from(post["likes"] ?? []),
                  ),
                );
              } else {
                return WallPost(
                  message: post["message"],
                  user: post["email"],
                  time: post["time"],
                  postId: post.id,
                  likes: List<String>.from(post["likes"] ?? []),
                );
              }
            },
          );
        } else {
          return Center(
            child: Text(widget.noDataMessage),
          );
        }
      },
    );
  }

  Container dismissableBackground(Color bgColor, IconData actionIcon) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Icon(
              actionIcon,
              color: Colors.white,
              size: 28.0,
            ),
          )
        ],
      ),
    );
  }
}
