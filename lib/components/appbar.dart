import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/pages/my_post.dart';
import 'package:wall_app/pages/saved_post.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showMoreOptions;
  const MyAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showMoreOptions = false,
  });

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      elevation: 0.0,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.grey[300]!.withOpacity(0.97),
      actions: showMoreOptions
          ? [
              PopupMenuButton(
                tooltip: 'More options',
                color: Colors.grey.shade200,
                menuPadding: const EdgeInsets.all(4),
                icon: const Icon(Icons.more_horiz_outlined),
                onSelected: (value) {
                  if (value == 'My Posts') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPost(),
                      ),
                    );
                  } else if (value == 'Saved Posts') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedPost(),
                      ),
                    );
                  } else if (value == 'Logout') {
                    signOut();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'My Posts', 'Saved Posts', 'Logout'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
