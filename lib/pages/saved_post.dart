import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/appbar.dart';
import 'package:wall_app/components/stream_builder.dart';
import 'package:wall_app/services/database.dart';

class SavedPost extends StatefulWidget {
  const SavedPost({super.key});

  @override
  State<SavedPost> createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      appBar: const MyAppBar(
        title: 'SAVED POSTS',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          children: [
            Expanded(
              child: MyStreamBuilder(
                stream:
                    SaveUserPost(uid: currentUser!.uid).getSavedPostsByUser(),
                noDataMessage: 'There are no saved posts!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
