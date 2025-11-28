import 'package:flutter/material.dart';
import 'goal_model.dart';
import 'assign_accounts_screen.dart';

class SelectGoalForAccountsScreen extends StatelessWidget {
  final List<Goal> goals;

  const SelectGoalForAccountsScreen({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Which accounts do you want to use to track your goals?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Subtitle
            const Text(
              "Assign accounts to your goals to track your progress automatically as balances change.",
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 30),

            // List of Goals
            Expanded(
              child: ListView.separated(
                itemCount: goals.length,
                separatorBuilder: (context, index) => const Divider(height: 30),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the next screen (Image 5) for this specific goal
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AssignAccountsScreen(goal: goal))
                      );
                    },
                    child: Container(
                      color: Colors.transparent, // Ensures the whole area is clickable
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Goal Header Row
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(goal.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#${index + 1}", style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                                  Text(goal.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Progress Bar
                          LinearProgressIndicator(
                            value: 0.05, // Dummy progress
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.green,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\$${goal.currentAmount.toInt()} paid of \$${goal.targetAmount.toInt()}",
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}