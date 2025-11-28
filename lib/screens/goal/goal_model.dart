// lib/screens/goal/goal_model.dart

class Goal {
  final String title;
  final double currentAmount;
  final double targetAmount;
  final String imageUrl;

  Goal({
    required this.title,
    required this.currentAmount,
    required this.targetAmount,
    this.imageUrl = "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?q=80&w=1000&auto=format&fit=crop",
  });
}