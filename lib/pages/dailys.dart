import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dailys extends StatefulWidget {
  const Dailys({super.key});

  @override
  State<Dailys> createState() => DailysState();
}

class DailysState extends State<Dailys> {
  final user = FirebaseAuth.instance.currentUser!;
  final _dailyTodoController = TextEditingController();

  Future<void> addDailyTodoToFirebase() async {
    if (_dailyTodoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Title cannot be empty"),
      ));
    } else {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'dailys': FieldValue.arrayUnion([
          {
            'title': _dailyTodoController.text.trim(),
          }
        ])
      });

      _dailyTodoController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Daily Todo added successfully"),
      ));
    }
  }

  Future<void> removeDaily(String title) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'dailys': FieldValue.arrayRemove([
          {
            'title': title,
          }
        ])
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Daily Todo removed successfully"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error while removing daily todo"),
      ));
    }
  }

  Future openDailyDialog() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add a daily todo to your list',
          ),
          content: TextField(
              controller: _dailyTodoController,
              decoration: const InputDecoration(hintText: 'Enter a title')),
          actions: [
            TextButton(
                onPressed: () async {
                  await addDailyTodoToFirebase();
                  Navigator.pop(context);
                },
                child: const Text('Add')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _dailyTodoController.clear();
                },
                child: const Text('Cancel')),
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDailyDialog();
        },
        backgroundColor: const Color.fromARGB(255, 0, 18, 32),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Daily Todos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 18, 32),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>?;
            var dailys = userData?['dailys'];

            if (dailys.length == 0) {
              return const Center(child: Text('No daily todos found.'));
            } else {
              return ListView.builder(
                itemCount: dailys.length,
                itemBuilder: (context, index) {
                  var daily = dailys[index] as Map<String, dynamic>;
                  return Slidable(
                    key: ValueKey(dailys[index]),
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: ((context) async {
                            // await removeDaily(title);
                            var title = daily['title'];
                            await removeDaily(title);
                          }),
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                        )
                      ],
                    ),
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(width: 0.5)),
                      title: Text(daily['title']),
                      onTap: () {
                        // Navigate to the daily detail screen
                      },
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
