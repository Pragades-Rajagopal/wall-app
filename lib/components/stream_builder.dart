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

  Future<void> saveUserPost(String postId) async {
    await SaveUserPost(uid: currentUser?.uid).savePost(postId);
    if (mounted) {
      showSnackBar(context, 'POST SAVED', duration: 1);
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
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 6.0,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
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
                    } else if (widget.dismissAction == 'deletePost') {
                      deleteUserPost(post.id);
                    }
                    return false;
                  },
                  background: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Icon(
                            Icons.bookmark,
                            color: Colors.white,
                            size: 28.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  child: WallPost(
                    message: post["message"],
                    user: post["email"],
                    time: post["time"],
                  ),
                );
              } else {
                return WallPost(
                  message: post["message"],
                  user: post["email"],
                  time: post["time"],
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
}
