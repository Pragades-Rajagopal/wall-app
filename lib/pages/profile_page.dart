import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/appbar.dart';
import 'package:wall_app/components/text_box.dart';
import 'package:wall_app/services/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> editField(String field, String oldValue) async {
    final TextEditingController textController = TextEditingController();
    textController.text = oldValue;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Edit $field',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceBright,
            fontSize: 22.0,
          ),
          decoration: InputDecoration(
            hintText: 'Enter new ${field.toLowerCase()}',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
            focusColor: Theme.of(context).colorScheme.tertiary,
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                await Users(email: currentUser!.email!).updateInfo(
                  field.toLowerCase(),
                  textController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const MyAppBar(title: 'PROFILE'),
      body: StreamBuilder(
        stream: Users(email: currentUser!.email!).getInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const SizedBox(height: 24),
                const Icon(
                  Icons.person,
                  size: 72,
                ),
                const SizedBox(height: 12),
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceBright,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    bottom: 20,
                  ),
                  child: Text(
                    'Profile info',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                ),
                MyTextBox(
                  text: userData["username"],
                  sectionName: 'Username',
                  onPressed: () => editField('Username', userData["username"]),
                ),
                MyTextBox(
                  text: userData["bio"],
                  sectionName: 'Bio',
                  onPressed: () => editField('Bio', userData["bio"]),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.surfaceBright,
              strokeWidth: 6.0,
            ),
          );
        },
      ),
    );
  }
}
