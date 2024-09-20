import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_project/pages/homepage.dart';

class TodoDetails extends StatefulWidget {
  final String todo_work;
  final Timestamp todo_time;
  const TodoDetails(
      {super.key, required this.todo_work, required this.todo_time});

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> markAsDone(String task, Timestamp time) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'todo': FieldValue.arrayRemove([
          {'task': task, 'time': time}
        ])
      });

      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'done': FieldValue.arrayUnion([
          {'task': task, 'time': time}
        ])
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

  Future<void> removeTodo(String task, Timestamp time) async {
    try {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'todo': FieldValue.arrayRemove([
          {'task': task, 'time': time}
        ])
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Homepage()));

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
            'Task Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 18, 32),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                widget.todo_work,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Initiated at: ${widget.todo_time.toDate()}"),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      await markAsDone(widget.todo_work, widget.todo_time);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task completed'),
                        ),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Homepage()));
                    },
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[500]),
                    onPressed: () async {
                      await removeTodo(widget.todo_work, widget.todo_time);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ))
              ],
            )
          ],
        ));
  }
}
