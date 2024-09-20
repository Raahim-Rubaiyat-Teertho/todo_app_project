import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final user = FirebaseAuth.instance.currentUser!;
  var toComplete = 0;
  var completed = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    try {
      final todoDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        toComplete = todoDoc.data()?['todo']?.length ?? 0;
        completed = todoDoc.data()?['done']?.length ?? 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error getting documents: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 18, 32),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Provide a fixed height for the PieChart
                SizedBox(
                  height: 300, // You can adjust the height as needed
                  child:
                      PieChart(PieChartData(centerSpaceRadius: 80, sections: [
                    PieChartSectionData(
                        color: Colors.amber,
                        title: 'Remaining: $toComplete',
                        value: toComplete.toDouble(),
                        titleStyle: const TextStyle(fontSize: 18)),
                    PieChartSectionData(
                        color: Colors.green,
                        title: 'Finished: $completed',
                        value: completed.toDouble(),
                        titleStyle: const TextStyle(fontSize: 18))
                  ])),
                ),

                toComplete > completed
                    ? const Center(
                        child: Text(
                        'Come on! Pick up the pace!',
                        style: TextStyle(fontSize: 18),
                      ))
                    : const Center(
                        child: Text(
                        'You are doing great! Keep at it!',
                        style: TextStyle(fontSize: 18),
                      ))
              ],
            ),
    );
  }
}
