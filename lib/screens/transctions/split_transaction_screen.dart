import 'package:flutter/material.dart';
import 'transaction_model.dart';
import 'add_split_screen.dart';

class SplitTransactionScreen extends StatefulWidget {
  final Transaction originalTransaction;

  const SplitTransactionScreen({super.key, required this.originalTransaction});

  @override
  State<SplitTransactionScreen> createState() => _SplitTransactionScreenState();
}

class _SplitTransactionScreenState extends State<SplitTransactionScreen> {
  List<Transaction> _splits = [];

  // Helper to calculate how much money is left to assign
  double get _remainingAmount {
    double totalSplit = _splits.fold(0, (sum, item) => sum + item.amount);
    return widget.originalTransaction.amount - totalSplit;
  }

  void _addSplit() async {
    // Open the Add Screen, passing the remaining amount
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddSplitScreen(
          totalAmount: widget.originalTransaction.amount,
          remainingAmount: _remainingAmount,
          originalDate: widget.originalTransaction.date,
          isExpense: widget.originalTransaction.isExpense,
        ),
      ),
    );

    if (result != null && result is Transaction) {
      setState(() {
        _splits.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CloseButton(color: Colors.black),
        title: const Text("Split Transaction", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Splitting a transaction will create individual transactions that you can categorize and manage separately.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // ORIGINAL SECTION
                  Text("Original", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.originalTransaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            "\$${widget.originalTransaction.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: widget.originalTransaction.isExpense ? Colors.black : Colors.green,
                                fontWeight: FontWeight.bold
                            )
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // SPLITS LIST SECTION
                  if (_splits.isNotEmpty) ...[
                    Text("Splits", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ..._splits.map((split) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                      ),
                      child: Row(
                        children: [
                          Text(split.categoryEmoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Text(split.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text("\$${split.amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )).toList(),
                    const SizedBox(height: 20),
                  ],

                  // ADD SPLIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _remainingAmount > 0 ? _addSplit : null, // Disable if 0 left
                      icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                      label: const Text("Add split", style: TextStyle(color: Colors.black)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM BAR (Matches Image 2 Screen 2)
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("LEFT TO SPLIT", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(
                        "\$${_remainingAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            // Turn Green if 0.00, else Black (Matches screenshot)
                            color: _remainingAmount == 0 ? Colors.green : Colors.black
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800],
                        disabledBackgroundColor: Colors.orange[200],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      // Only enable Save if remaining amount is 0
                      onPressed: _remainingAmount == 0 && _splits.isNotEmpty
                          ? () {
                        // Return the NEW splits to the previous screen
                        Navigator.pop(context, _splits);
                      }
                          : null,
                      child: Text(
                        _splits.isEmpty ? "Add a split to start" : "Split into ${_splits.length} transactions",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}