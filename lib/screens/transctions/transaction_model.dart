import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String categoryEmoji;
  final bool isExpense;
  // NEW FIELDS ADDED HERE
  final String? notes;
  final String? goalName;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.categoryEmoji,
    required this.isExpense,
    this.notes,
    this.goalName,
  });
}