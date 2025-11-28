// lib/screens/goal/goal_priority_screen.dart
import 'package:flutter/material.dart';
import 'goal_model.dart';

class GoalPriorityScreen extends StatefulWidget {
  final List<Goal> goals;
  const GoalPriorityScreen({super.key, required this.goals});

  @override
  State<GoalPriorityScreen> createState() => _GoalPriorityScreenState();
}

class _GoalPriorityScreenState extends State<GoalPriorityScreen> {
  late List<Goal> _currentGoals;

  @override
  void initState() {
    super.initState();
    _currentGoals = List.from(widget.goals);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final Goal item = _currentGoals.removeAt(oldIndex);
      _currentGoals.insert(newIndex, item);
    });
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "How do you want to prioritize your goals?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ReorderableListView(
              onReorder: _onReorder,
              children: [
                for (int i = 0; i < _currentGoals.length; i++)
                  ListTile(
                    key: ValueKey(_currentGoals[i].title), // Using title as key for now
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.drag_handle, color: Colors.grey),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(_currentGoals[i].imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("#${i + 1}", style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text(_currentGoals[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}