class Book {
  final String id;
  final String name;

  const Book({ required this.id, required this.name });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'] as String,
    name: json['name'] as String,
  );
}