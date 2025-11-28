// lib/screens/goal/goals_screen.dart
import 'package:flutter/material.dart';
import 'goal_model.dart';
import 'goal_detail_screen.dart';
import 'assign_accounts_screen.dart';
import 'goal_priority_screen.dart';
import 'select_goal_accounts_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  // THE LIST OF GOALS
  List<Goal> myGoals = [
    Goal(title: "Assign debt accounts", currentAmount: 0, targetAmount: 500),
  ];

  // FUNCTION TO ADD A NEW GOAL
  void _addNewGoal(String title, double target) {
    setState(() {
      myGoals.add(Goal(
        title: title,
        currentAmount: 0,
        targetAmount: target,
      ));
    });
  }

  // DIALOG POPUP TO TYPE GOAL DETAILS
  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Goal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Goal Name (e.g. Car)"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Target Amount (e.g. 5000)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                _addNewGoal(
                  titleController.text,
                  double.parse(amountController.text),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Goals", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onSelected: (value) {
              if (value == 'add') {
                _showAddGoalDialog();
              } else if (value == 'edit_accounts') {
                // Navigate to the list of goals selection screen
                Navigator.push(context, MaterialPageRoute(builder: (_) => SelectGoalForAccountsScreen(goals: myGoals)));
              } else if (value == 'priorities') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GoalPriorityScreen(goals: myGoals)));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'add',
                  child: ListTile(leading: Icon(Icons.add), title: Text("Add a goal"), contentPadding: EdgeInsets.zero),
                ),
                const PopupMenuItem(
                  value: 'edit_accounts',
                  child: ListTile(leading: Icon(Icons.attach_money), title: Text("Edit accounts"), contentPadding: EdgeInsets.zero),
                ),
                const PopupMenuItem(
                  value: 'priorities',
                  child: ListTile(leading: Icon(Icons.priority_high), title: Text("Edit goal priorities"), contentPadding: EdgeInsets.zero),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: myGoals.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final goal = myGoals[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoalDetailScreen(goal: goal)),
              );
            },
            child: _buildGoalCard(goal),
          );
        },
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(goal.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "\$${goal.currentAmount.toInt()} of \$${goal.targetAmount.toInt()}",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}