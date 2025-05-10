class Todo {
  final String todoId;

  final String content;

  bool isCompleted;

  final TodoCategory category;

  Todo({
    required this.todoId,
    required this.content,
    this.isCompleted = false,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'todoId': todoId,
        'content': content,
        'isCompleted': isCompleted,
        'category': category.name,
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      todoId: json['todoId'],
      content: json['content'],
      isCompleted: json['isCompleted'],
      category: TodoCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TodoCategory.other,
      ),
    );
  }
}

enum TodoCategory {
  
  work,
  
  personal,
  
  shopping,
  
  health,
  
  travel,
  
  finance,
  
  education,
  
  entertainment,
  
  home,
  
  fitness,
  
  hobbies,
  
  family,
  
  friends,
  
  selfCare,
  
  spirituality,
  
  community,
  
  volunteering,
  
  pets,
  
  technology,
  
  fashion,
  
  food,
  
  sports,
  
  music,
  
  art,
  
  books,
  
  movies,
  
  games,
  
  photography,
  
  gardening,
  
  crafts,
  
  writing,
  
  cooking,
  
  homeImprovement,
  
  other,
}
