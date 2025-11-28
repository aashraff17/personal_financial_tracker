import 'package:flutter/material.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Map of categories to emojis
    final categories = {
      "Income": [
        {"name": "Business Income", "emoji": "💰"},
        {"name": "Interest", "emoji": "💸"},
        {"name": "Other Income", "emoji": "💵"},
      ],
      "Food & Dining": [
        {"name": "Restaurants", "emoji": "🍔"},
        {"name": "Groceries", "emoji": "🛒"},
        {"name": "Coffee", "emoji": "☕"},
      ],
      "Auto & Transport": [
        {"name": "Gas", "emoji": "⛽"},
        {"name": "Public Transit", "emoji": "🚆"},
      ],
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CloseButton(color: Colors.black),
        title: const Text("Select category", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        children: categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header (Gray background)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey.shade100,
                child: Text(entry.key, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              ),
              // Category Items
              ...entry.value.map((item) => ListTile(
                leading: Text(item['emoji']!, style: const TextStyle(fontSize: 24)),
                title: Text(item['name']!),
                onTap: () {
                  // Return the selected category back to the previous screen
                  Navigator.pop(context, item);
                },
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}