import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Number restricting
import 'package:intl/intl.dart';
import 'select_category_screen.dart';
import 'transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // NEW: Controller for the custom goal text
  final TextEditingController _customGoalController = TextEditingController();

  bool isDebit = true;
  DateTime selectedDate = DateTime.now();
  Map<String, String>? selectedCategory;
  String? selectedGoal;

  // List of goals with "Other" at the end
  final List<String> myGoals = ["New Laptop", "Emergency Fund", "Vacation", "Car Loan", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CloseButton(color: Colors.black),
        title: const Text("New Transaction", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. DEBIT / CREDIT TOGGLE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggleBtn("DEBIT", true),
                      const SizedBox(width: 10),
                      _buildToggleBtn("CREDIT", false),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 2. AMOUNT INPUT (STRICT NUMBERS ONLY)
                  TextField(
                    controller: _amountController,
                    textAlign: TextAlign.center,
                    // This forces the keyboard to be numbers only
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    // This STRICTLY blocks any non-number characters from being pasted or typed
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: "\$0.00",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black26),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 3. MERCHANT INPUT
                  _buildInputRow("Merchant", child: TextField(
                    controller: _merchantController,
                    decoration: const InputDecoration(hintText: "Merchant name...", border: InputBorder.none),
                  )),
                  _buildDivider(),

                  // 4. DATE PICKER
                  _buildInputRow("Date", child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030)
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: Text(DateFormat('MMMM d, y').format(selectedDate)),
                  )),
                  _buildDivider(),

                  // 5. CATEGORY SELECTOR
                  _buildInputRow("Category", child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectCategoryScreen()),
                      );
                      if (result != null) {
                        setState(() {
                          selectedCategory = result as Map<String, String>;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        if (selectedCategory != null) Text(selectedCategory!['emoji']!, style: const TextStyle(fontSize: 20)),
                        if (selectedCategory != null) const SizedBox(width: 8),
                        Text(
                            selectedCategory?['name'] ?? "Select category...",
                            style: TextStyle(color: selectedCategory == null ? Colors.grey : Colors.black)
                        ),
                      ],
                    ),
                  )),
                  _buildDivider(),

                  // 6. GOAL SELECTION (With "Other" Logic)
                  _buildInputRow("Goal", child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text("Select goal...", style: TextStyle(color: Colors.grey)),
                          value: selectedGoal,
                          icon: const Icon(Icons.chevron_right, color: Colors.grey),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGoal = newValue;
                            });
                          },
                          items: myGoals.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // IF "Other" IS SELECTED, SHOW THIS TEXT FIELD
                      if (selectedGoal == "Other")
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: TextField(
                            controller: _customGoalController,
                            decoration: InputDecoration(
                              hintText: "Enter custom goal name",
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                    ],
                  )),
                  _buildDivider(),

                  // 7. NOTES INPUT
                  _buildInputRow("Notes", child: TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                        hintText: "Add notes...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey)
                    ),
                  )),
                ],
              ),
            ),
          ),

          // ADD BUTTON
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
                onPressed: _saveTransaction, // Calling the function below
                child: const Text("Add Transaction", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LOGIC TO SAVE
  void _saveTransaction() {
    // 1. Validate Amount
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter an amount")));
      return;
    }
    // 2. Validate Merchant
    if (_merchantController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a merchant name")));
      return;
    }

    // 3. Handle Goal Logic (Did they pick "Other"?)
    String? finalGoalName;
    if (selectedGoal == "Other") {
      finalGoalName = _customGoalController.text;
    } else {
      finalGoalName = selectedGoal;
    }

    // 4. Create Transaction Object
    double amount = double.tryParse(_amountController.text) ?? 0.0;

    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: _merchantController.text,
      amount: amount,
      date: selectedDate,
      category: selectedCategory?['name'] ?? "Uncategorized",
      categoryEmoji: selectedCategory?['emoji'] ?? "❔",
      isExpense: isDebit,
      notes: _notesController.text,
      goalName: finalGoalName,
    );

    // 5. Send back to previous screen
    Navigator.pop(context, newTx);
  }

  Widget _buildToggleBtn(String text, bool isBtnDebit) {
    bool isSelected = isBtnDebit == isDebit;
    return GestureDetector(
      onTap: () => setState(() => isDebit = isBtnDebit),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(isBtnDebit ? Icons.remove_circle_outline : Icons.add_circle_outline,
                size: 16, color: isSelected ? Colors.black : Colors.grey),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns label to top if child is tall
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0), // Slight adjustment for alignment
            child: SizedBox(width: 100, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1);
}