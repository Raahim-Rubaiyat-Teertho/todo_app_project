import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> removeTodo(String task, Timestamp time) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'done': FieldValue.arrayRemove([
          {'task': task, 'time': time}
        ])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task removed'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Task History',
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
            var dones = userData?['done'];

            if (dones.length == 0) {
              return const Center(child: Text('No tasks found'));
            } else {
              return ListView.builder(
                itemCount: dones.length,
                itemBuilder: (context, index) {
                  var task = dones[index]['task'];
                  var time = dones[index]['time'];
                  DateTime d = time.toDate();

                  return Slidable(
                    startActionPane:
                        ActionPane(motion: StretchMotion(), children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await removeTodo(task, time);
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      )
                    ]),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          task,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      subtitle: Text(d.toString()),
                      onTap: () {},
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
