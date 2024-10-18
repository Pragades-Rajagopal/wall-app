import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/button.dart';
import 'package:wall_app/components/common.dart';
import 'package:wall_app/components/text_field.dart';
import 'package:wall_app/services/authentication.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  void signIn() async {
    try {
      showLoadingIndicator(context);
      if (emailTextController.text.isNotEmpty &&
          passwordTextController.text.isNotEmpty) {
        await Authentication().signIn(
          emailTextController.text,
          passwordTextController.text,
        );
      }
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        Navigator.pop(context);
        showSnackBar(context, error.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 96.0,
                  height: 96.0,
                  child: CircleAvatar(
                    foregroundImage: AssetImage('assets/app_icon.png'),
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Welcome back to the community!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 30.0),
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 12.0),
                MyTextField(
                  controller: passwordTextController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                MyButton(
                  text: 'Sign In',
                  onTap: signIn,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
