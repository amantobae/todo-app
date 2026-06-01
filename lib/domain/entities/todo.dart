class Todo {
  const Todo({
    required this.id,
    required this.title,
    this.description = '',
    required this.isCompleted,
    required this.createdAt,
    required this.sortOrder,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final int sortOrder;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    int? sortOrder,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
