import 'package:flutter/material.dart';
import 'transaction_model.dart';
import 'select_category_screen.dart';

class AddSplitScreen extends StatefulWidget {
  final double totalAmount;
  final double remainingAmount;
  final DateTime originalDate;
  final bool isExpense;

  const AddSplitScreen({
    super.key,
    required this.totalAmount,
    required this.remainingAmount,
    required this.originalDate,
    required this.isExpense,
  });

  @override
  State<AddSplitScreen> createState() => _AddSplitScreenState();
}

class _AddSplitScreenState extends State<AddSplitScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  Map<String, String>? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CloseButton(color: Colors.black),
        title: const Text("Add Split", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // AMOUNT INPUT
                  TextField(
                    controller: _amountController,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "\$0.00",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // "LEFT TO SPLIT" INDICATOR (Under the amount)
                  Text(
                    "\$${widget.remainingAmount.toStringAsFixed(2)} left to split",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  // FORM FIELDS
                  _buildInputRow("Merchant", child: TextField(
                    controller: _merchantController,
                    decoration: const InputDecoration(hintText: "Merchant name...", border: InputBorder.none),
                  )),
                  const Divider(height: 1),
                  _buildInputRow("Category", child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectCategoryScreen()),
                      );
                      if (result != null) {
                        setState(() => selectedCategory = result as Map<String, String>);
                      }
                    },
                    child: Row(
                      children: [
                        if (selectedCategory != null) Text(selectedCategory!['emoji']!, style: const TextStyle(fontSize: 20)),
                        if (selectedCategory != null) const SizedBox(width: 8),
                        Text(selectedCategory?['name'] ?? "Select category...", style: TextStyle(color: selectedCategory == null ? Colors.grey : Colors.black)),
                      ],
                    ),
                  )),
                  const Divider(height: 1),
                ],
              ),
            ),
          ),

          // SAVE BUTTON
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Validation: Check if amount is valid and not more than remaining
                  double? enteredAmount = double.tryParse(_amountController.text);
                  if (enteredAmount != null && enteredAmount > 0) {
                    // Create new transaction object
                    final newTx = Transaction(
                      id: DateTime.now().toString(),
                      title: _merchantController.text.isEmpty ? "Split Transaction" : _merchantController.text,
                      amount: enteredAmount,
                      date: widget.originalDate,
                      category: selectedCategory?['name'] ?? "Uncategorized",
                      categoryEmoji: selectedCategory?['emoji'] ?? "❔",
                      isExpense: widget.isExpense,
                    );
                    Navigator.pop(context, newTx);
                  }
                },
                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(String label, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: child),
        ],
      ),
    );
  }
}