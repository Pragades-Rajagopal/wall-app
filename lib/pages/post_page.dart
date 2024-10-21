import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/appbar.dart';
import 'package:wall_app/components/comment.dart';
import 'package:wall_app/components/icon_button.dart';
import 'package:wall_app/components/text_field.dart';
import 'package:wall_app/helpers/helper_functions.dart';
import 'package:wall_app/services/database.dart';

class PostPage extends StatefulWidget {
  final String postId;
  final String message;
  final String user;
  final String time;
  final List<String> likes;

  const PostPage({
    super.key,
    required this.postId,
    required this.message,
    required this.user,
    required this.time,
    required this.likes,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final commentTextController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _showSaveLoadingIndicator = false;

  void _toggleSaveLoadingIndicator() {
    setState(() {
      _showSaveLoadingIndicator = !_showSaveLoadingIndicator;
    });
  }

  void postComment() async {
    if (commentTextController.text.isNotEmpty) {
      _toggleSaveLoadingIndicator();
      String? username = await Users(email: currentUser!.email!).getUsername();
      await Comment(widget.postId).addComment(
        commentTextController.text,
        username,
      );
      setState(() {
        commentTextController.text = '';
      });
      _toggleSaveLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      // extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const MyAppBar(
        title: 'POST',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 120),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(
                widget.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  fontSize: 22.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Comments",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    widget.likes.length > 1
                        ? '${widget.likes.length} likes'
                        : '${widget.likes.length} like',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Comment(widget.postId).getCommentsForPost(),
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
                        'Unable to fetch posts right now.\nTry again after sometime.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final comment = snapshot.data!.docs[index];
                        return CommentList(
                          comment: comment["comment"],
                          commentedby: comment["commentedBy"],
                          commentedAt: getFormattedTime(comment["commentedAt"]),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No comments posted yet!'),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: commentTextController,
                      hintText: 'Comment something...',
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  _showSaveLoadingIndicator
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.surfaceBright,
                            strokeWidth: 4.0,
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: MyIconButton(
                            onPressed: postComment,
                            icon: Icons.add_comment_outlined,
                            color: Colors.white70,
                            iconSize: 28.0,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
