import 'package:flutter/material.dart';

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

final categoryToIcon = {
  TodoCategory.work: Icons.work,
  TodoCategory.personal: Icons.person,
  TodoCategory.shopping: Icons.shopping_cart,
  TodoCategory.health: Icons.health_and_safety,
  TodoCategory.travel: Icons.travel_explore,
  TodoCategory.finance: Icons.monetization_on,
  TodoCategory.education: Icons.school,
  TodoCategory.entertainment: Icons.movie,
  TodoCategory.home: Icons.home,
  TodoCategory.fitness: Icons.fitness_center,
  TodoCategory.hobbies: Icons.hiking_rounded,
  TodoCategory.family: Icons.family_restroom,
  TodoCategory.friends: Icons.group,
  TodoCategory.selfCare: Icons.self_improvement,
  TodoCategory.spirituality: Icons.church,
  TodoCategory.community: Icons.people_alt,
  TodoCategory.volunteering: Icons.volunteer_activism,
  TodoCategory.pets: Icons.pets,
  TodoCategory.technology: Icons.computer,
  TodoCategory.fashion: Icons.checkroom,
  TodoCategory.food: Icons.fastfood,
  TodoCategory.sports: Icons.sports_baseball,
  TodoCategory.music: Icons.music_note,
  TodoCategory.art: Icons.brush,
  TodoCategory.books: Icons.book,
  TodoCategory.movies: Icons.movie_creation_outlined,
  TodoCategory.games: Icons.videogame_asset_outlined,
  TodoCategory.photography: Icons.photo_camera_back_outlined,
  TodoCategory.gardening: Icons.grass_outlined,
  TodoCategory.crafts: Icons.art_track_outlined,
  TodoCategory.writing: Icons.create_outlined,
  TodoCategory.cooking: Icons.kitchen_outlined,
  TodoCategory.homeImprovement: Icons.build_circle_outlined,
  TodoCategory.other: Icons.category,
};

class Todo {
  final int todoId;
  final String content;
  final bool completed;
  final bool recurrent;
  final TodoCategory category;

  Todo({
    required this.todoId,
    required this.content,
    this.completed = false,
    this.recurrent = false,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'todoId': todoId,
        'content': content,
        'completed': completed,
        'recurrent': recurrent,
        'category': category.name,
      };

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      todoId: json['todoId'],
      content: json['content'],
      completed: json['completed'],
      recurrent: json['recurrent'],
      category: TodoCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TodoCategory.other,
      ),
    );
  }
}
