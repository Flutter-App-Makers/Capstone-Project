import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String todoId;

  @HiveField(1)
  final String content;

  @HiveField(2)
  bool isCompleted;

  @HiveField(4)
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

@HiveType(typeId: 1)
enum TodoCategory {
  @HiveField(0)
  work,
  @HiveField(1)
  personal,
  @HiveField(2)
  shopping,
  @HiveField(3)
  health,
  @HiveField(4)
  travel,
  @HiveField(5)
  finance,
  @HiveField(6)
  education,
  @HiveField(7)
  entertainment,
  @HiveField(8)
  home,
  @HiveField(9)
  fitness,
  @HiveField(10)
  hobbies,
  @HiveField(11)
  family,
  @HiveField(12)
  friends,
  @HiveField(13)
  selfCare,
  @HiveField(14)
  spirituality,
  @HiveField(15)
  community,
  @HiveField(16)
  volunteering,
  @HiveField(17)
  pets,
  @HiveField(18)
  technology,
  @HiveField(19)
  fashion,
  @HiveField(20)
  food,
  @HiveField(21)
  sports,
  @HiveField(22)
  music,
  @HiveField(23)
  art,
  @HiveField(24)
  books,
  @HiveField(25)
  movies,
  @HiveField(26)
  games,
  @HiveField(27)
  photography,
  @HiveField(28)
  gardening,
  @HiveField(29)
  crafts,
  @HiveField(30)
  writing,
  @HiveField(31)
  cooking,
  @HiveField(32)
  homeImprovement,
  @HiveField(33)
  other,
}
