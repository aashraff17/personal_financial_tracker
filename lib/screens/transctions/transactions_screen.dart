import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction_model.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart'; // Ensure this is imported

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];

  // NAVIGATE TO ADD SCREEN
  void _navigateToAddTransaction() async {
    final newTransaction = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );

    if (newTransaction != null && newTransaction is Transaction) {
      setState(() {
        _transactions.insert(0, newTransaction);
      });
    }
  }

  // NAVIGATE TO DETAILS (AND HANDLE SPLIT OR DELETE)
  void _navigateToDetail(Transaction tx, int index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: tx))
    );

    // Case 1: Split Transaction occurred (Result is a List)
    if (result != null && result is List<Transaction>) {
      setState(() {
        _transactions.removeAt(index);
        _transactions.insertAll(index, result);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaction split successfully")));
    }

    // Case 2: Delete Transaction occurred (Result is string 'delete')
    else if (result == 'delete') {
      setState(() {
        _transactions.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaction deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Transactions", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _navigateToAddTransaction,
      ),
      body: _transactions.isEmpty
          ? _buildEmptyState()
          : _buildTransactionList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
            child: const Icon(Icons.attach_money, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Text("No transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Add a transaction to get started.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        return GestureDetector(
          onTap: () => _navigateToDetail(tx, index), // Calls the function that handles delete
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(tx.categoryEmoji, style: const TextStyle(fontSize: 24)),
            ),
            title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(DateFormat('MMM d').format(tx.date)),
            trailing: Text(
              tx.isExpense ? "-\$${tx.amount.toStringAsFixed(2)}" : "+\$${tx.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: tx.isExpense ? Colors.black : Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }
}