import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/appbar.dart';
import 'package:wall_app/components/drawer.dart';
import 'package:wall_app/components/icon_button.dart';
import 'package:wall_app/components/stream_builder.dart';
import 'package:wall_app/components/text_field.dart';
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
  bool _showSaveLoadingIndicator = false;

  void _toggleSaveLoadingIndicator() {
    setState(() {
      _showSaveLoadingIndicator = !_showSaveLoadingIndicator;
    });
  }

  void postMessage() async {
    if (messageTextController.text.isNotEmpty) {
      _toggleSaveLoadingIndicator();
      await UserPost().savePost(
        currentUser?.email,
        messageTextController.text,
      );
      setState(() {
        messageTextController.text = '';
      });
      _toggleSaveLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      appBar: const MyAppBar(title: 'WALL'),
      drawer: MyDrawer(scaffoldState: _scaffoldState),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          children: [
            Expanded(
              // stream: UserPost().getAllPosts(),

              child: MyStreamBuilder(
                stream: UserPost().getAllPosts(),
                noDataMessage: '',
                isDismissableAction: true,
              ),
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
                  const SizedBox(
                    width: 8.0,
                  ),
                  _showSaveLoadingIndicator
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          child: const CircularProgressIndicator(
                            color: Colors.black,
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
                            onPressed: postMessage,
                            icon: Icons.arrow_circle_up,
                            color: Colors.white70,
                            iconSize: 36.0,
                          ),
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
