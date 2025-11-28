// lib/screens/goal/assign_accounts_screen.dart
import 'package:flutter/material.dart';
import 'goal_model.dart';

class AssignAccountsScreen extends StatelessWidget {
  final Goal goal;

  const AssignAccountsScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Assign your accounts", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(goal.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("#1", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text(goal.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: 0.05,
                  backgroundColor: Colors.grey.shade200,
                  color: Colors.green,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$0 paid of \$${goal.targetAmount.toInt()}",
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Center(
              child: Text(
                "No accounts",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}