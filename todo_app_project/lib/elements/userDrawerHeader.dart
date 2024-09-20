import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDrawerHeader extends StatefulWidget {
  const UserDrawerHeader({super.key});

  @override
  State<UserDrawerHeader> createState() => _UserDrawerHeaderState();
}

class _UserDrawerHeaderState extends State<UserDrawerHeader> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error fetching user data');
        } else if (snapshot.hasData && snapshot.data != null) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var firstName = userData['first_name'];
          var lastName = userData['last_name'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'WELCOME',
                style: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 2),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('$firstName $lastName')
            ],
          );
        } else {
          return const Text('User Data Not Found');
        }
      },
    );
  }
}
