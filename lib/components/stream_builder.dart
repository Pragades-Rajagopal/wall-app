import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/components/wall_post.dart';

class MyStreamBuilder extends StatelessWidget {
  final Stream<QuerySnapshot<Object?>> stream;
  final String noDataMessage;
  const MyStreamBuilder({
    super.key,
    required this.stream,
    required this.noDataMessage,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 6.0,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];
              return WallPost(
                message: post["message"],
                user: post["email"],
                time: post["time"],
              );
            },
          );
        } else {
          return Center(
            child: Text(noDataMessage),
          );
        }
      },
    );
  }
}
