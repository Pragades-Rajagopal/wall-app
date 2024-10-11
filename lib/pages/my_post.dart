import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/appbar.dart';
import 'package:wall_app/components/stream_builder.dart';
import 'package:wall_app/services/database.dart';

class MyPost extends StatefulWidget {
  const MyPost({super.key});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      appBar: const MyAppBar(
        title: 'MY POSTS',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          children: [
            Expanded(
              child: MyStreamBuilder(
                stream:
                    UserPost(email: currentUser!.email).getUserPostsByEmail(),
                noDataMessage: 'You have not posted yet!',
                isDismissableAction: true,
                dismissAction: 'deletePost',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
