import 'package:flutter/material.dart';
import 'goal_model.dart';
import 'customize_goal_screen.dart'; // Import the new screen

class GoalDetailScreen extends StatelessWidget {
  final Goal goal;

  const GoalDetailScreen({super.key, required this.goal});

  // FUNCTION TO SHOW DELETE DIALOG (Image 10)
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Delete goal", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            "Deleting this goal will disconnect it from the accounts you used, freeing them up for other goals. You will lose the history of this goal.",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text("Cancel", style: TextStyle(fontSize: 17, color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close screen (Go back to list)
                // Add actual delete logic here later
              },
              child: const Text("Delete", style: TextStyle(fontSize: 17, color: Colors.red)),
            ),
          ],
        );
      },
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // THE NEW POPUP MENU (Image 7)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'customize') {
                // Navigate to Customize Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CustomizeGoalScreen(goal: goal)),
                );
              } else if (value == 'delete') {
                // Show Delete Dialog
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'customize',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined, color: Colors.black),
                    title: Text("Customize goal"),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red), // Red Icon
                    title: Text("Delete goal", style: TextStyle(color: Colors.red)), // Red Text
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(goal.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(20),
              child: Text(
                goal.title,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Contributions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text("Contributions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildMockChart(goal),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Divider(thickness: 1, height: 1),

            // Settings
            Padding(
              padding: const EdgeInsets.all(20),
              child: const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildSettingsItem("Goal priority", "#1"),
            _buildSettingsItem("Accounts assigned", "Select your accounts"),
            _buildSettingsItem("Budget contributions", "\$${goal.targetAmount.toInt()}/mo"),
            _buildSettingsItem("Starting balance", "\$0"),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildMockChart(Goal goal) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomPaint(painter: DottedLinePainter(), child: Container(height: 1)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Budget", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("\$${goal.targetAmount.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            )
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMonthColumn("Jul", true),
            _buildMonthColumn("Aug", false),
            _buildMonthColumn("Sep", false),
            _buildMonthColumn("Oct", false),
            _buildMonthColumn("Nov", false),
            _buildMonthColumn("Dec", false),
          ],
        )
      ],
    );
  }

  Widget _buildMonthColumn(String month, bool isCurrent) {
    return Column(
      children: [
        Text(isCurrent ? "\$0" : "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 5),
        Container(width: 30, height: 2, color: isCurrent ? Colors.black : Colors.grey.shade300),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.5)),
        )
      ],
    );
  }

  Widget _buildSettingsItem(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey..strokeWidth = 1;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + 4, 0), paint);
      startX += 8;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}