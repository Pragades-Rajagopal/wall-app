import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> register(String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create a basic profile for the user after registration
    FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.email)
        .set({
      "username": email.split('@')[0],
      "bio": "Hey there folks!",
    });
  }
}
