import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_model.dart';
import 'split_transaction_screen.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

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
        title: Text(transaction.title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onSelected: (value) async {
              if (value == 'split') {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SplitTransactionScreen(originalTransaction: transaction)),
                );
                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              } else if (value == 'delete') {
                // FIXED: SEND DELETE SIGNAL BACK
                Navigator.pop(context, 'delete');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'split',
                  child: ListTile(leading: Icon(Icons.call_split), title: Text("Split transaction"), contentPadding: EdgeInsets.zero),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(leading: Icon(Icons.delete_outline, color: Colors.red), title: Text("Delete transaction", style: TextStyle(color: Colors.red)), contentPadding: EdgeInsets.zero),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              transaction.isExpense ? "-\$${transaction.amount.toStringAsFixed(2)}" : "+\$${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: transaction.isExpense ? Colors.black : Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            const Divider(height: 1),
            _buildDetailRow("Merchant", transaction.title),
            _buildDetailRow("Date", DateFormat('MMMM d, y').format(transaction.date)),
            _buildDetailRow("Category", transaction.category),

            // FIXED: Display the actual Goal Name
            _buildDetailRow("Goal", transaction.goalName ?? "No goal assigned"),

            // FIXED: Display the actual Notes
            _buildDetailRow("Notes", transaction.notes ?? "No notes"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis, // Prevents overflow if note is long
            ),
          ),
        ],
      ),
    );
  }
}