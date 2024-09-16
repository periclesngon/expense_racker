class Expense {
  final String id; // This should be a String, not a Future<dynamic>
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String type; // Assuming you have a 'type' field as well

  Expense(String string, {
    required this.id, // This expects a String
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });
}
