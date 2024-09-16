import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_project/elements/userDrawerHeader.dart';
import 'package:todo_app_project/pages/dailys.dart';
import 'package:todo_app_project/pages/history.dart';
import 'package:todo_app_project/pages/login.dart';
import 'package:todo_app_project/pages/stats.dart';
import 'package:todo_app_project/pages/todoDetails.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser!;
  final _titleController = TextEditingController();
  List<dynamic> todos = [];

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  Future<void> addToFirestore() async {
    if (_titleController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title cannot be empty'),
        ),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'todo': FieldValue.arrayUnion([
          {'task': _titleController.text.trim(), 'time': DateTime.now()}
        ])
      });

      _titleController.clear();

      final todoDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final todoList = todoDoc.data()?['todo'] as List<dynamic>?;

      if (todoList!.isNotEmpty) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Currently prioritized todos pending!',
              body: todoList[0]['task'],
              autoDismissible: false),
        );
      } else {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Congratulations!',
              body: 'You have completed all your tasks!',
              autoDismissible: false),
        );
      }
    }
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a new todo'),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Enter a title'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await addToFirestore();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task Created Successfully')));
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      });

  Future<void> updateTodosInFirestore() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'todo': todos}).then(
      (value) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Currently prioritized todos pending!',
              body: todos[0]['task'],
              autoDismissible: false),
        );
      },
    );
  }

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task completed'),
        ),
      );

      final todoDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final todoList = todoDoc.data()?['todo'] as List<dynamic>?;

      if (todoList!.isNotEmpty) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Currently prioritized todos pending!',
              body: todoList[0]['task'],
              autoDismissible: false),
        );
      } else {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Congratulations!',
              body: 'You have completed all your tasks!',
              autoDismissible: false),
        );
      }
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task removed'),
        ),
      );

      final todoDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final todoList = todoDoc.data()?['todo'] as List<dynamic>?;

      if (todoList!.isNotEmpty) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Currently prioritized todos pending!',
              body: todoList[0]['task'],
              autoDismissible: false),
        );
      } else {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Congratulations!',
              body: 'You have completed all your tasks!',
              autoDismissible: false),
        );
      }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        backgroundColor: const Color.fromARGB(255, 0, 18, 32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 18, 32),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(child: UserDrawerHeader()),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Homepage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_repeat),
              title: const Text('Daily Todos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Dailys(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Stats'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Stats()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const History(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            )
          ],
        ),
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
          todos = userData?['todo'] ?? [];

          if (todos.isEmpty) {
            return const Center(child: Text('No tasks found'));
          } else {
            return ReorderableListView.builder(
              itemCount: todos.length,
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = todos.removeAt(oldIndex);
                todos.insert(newIndex, item);
                setState(() {});
                await updateTodosInFirestore();
              },
              itemBuilder: (context, index) {
                var task = todos[index]['task'];
                var time = todos[index]['time'];
                DateTime d = time.toDate();

                return Slidable(
                  key: ValueKey(todos[index]),
                  startActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      onPressed: ((context) async {
                        await markAsDone(task, time);
                      }),
                      backgroundColor: Colors.green,
                      icon: Icons.done,
                    ),
                    SlidableAction(
                      onPressed: ((context) async {
                        await removeTodo(task, time);
                      }),
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                    )
                  ]),
                  child: ListTile(
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 0.5)),
                    trailing: const Icon(Icons.reorder_outlined),
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TodoDetails(
                                  todo_work: task, todo_time: time)));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
