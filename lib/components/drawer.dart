import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/pages/my_post.dart';
import 'package:wall_app/pages/saved_post.dart';

class MyDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;
  const MyDrawer({super.key, required this.scaffoldState});

  void _toggleDrawer() {
    if (scaffoldState.currentState!.isDrawerOpen) {
      scaffoldState.currentState!.openEndDrawer();
    } else {
      scaffoldState.currentState!.openDrawer();
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  builder: (context) => const MyPost(),
                ),
              );
            },
            child: const Text(
              'My posts',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
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
    );
  }
}
