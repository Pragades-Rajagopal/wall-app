import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/icon_button.dart';
import 'package:wall_app/components/text_field.dart';
import 'package:wall_app/components/wall_post.dart';
import 'package:wall_app/pages/saved_post.dart';
import 'package:wall_app/services/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final messageTextController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  void _toggleDrawer() {
    if (_scaffoldState.currentState!.isDrawerOpen) {
      _scaffoldState.currentState!.openEndDrawer();
    } else {
      _scaffoldState.currentState!.openDrawer();
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void postMessage() async {
    if (messageTextController.text.isNotEmpty) {
      await UserPost().savePost(
        currentUser?.email,
        messageTextController.text,
      );
    }
    setState(() {
      messageTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'WALL',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.withOpacity(0.95),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade300,
        elevation: 0.0,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DrawerHeader(
              child: Text('Actions'),
            ),
            TextButton(
              onPressed: () {
                _toggleDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedPost(),
                  ),
                );
              },
              child: const Text(
                'Saved posts',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: signOut,
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('user_posts')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return Dismissible(
                            key: Key(post["message"]),
                            direction: DismissDirection.startToEnd,
                            confirmDismiss: (_) async {
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
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 6.0,
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: messageTextController,
                      hintText: 'Write something on the wall...',
                      obscureText: false,
                    ),
                  ),
                  MyIconButton(
                    onPressed: postMessage,
                    icon: Icons.arrow_circle_up,
                    color: Colors.black,
                    iconSize: 36.0,
                  ),
                ],
              ),
            ),
            Text(
              'Logged in as ${currentUser?.email}',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
