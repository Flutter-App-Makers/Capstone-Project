import 'package:capstone_project/models/todo.dart';
import 'package:flutter/material.dart';

class TodoCategoryDropdown extends StatelessWidget {
  final TodoCategory selected;
  final ValueChanged<TodoCategory> onChanged;

  const TodoCategoryDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TodoCategory>(
      value: selected,
      decoration: const InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      isExpanded: true,
      items: TodoCategory.values.map((category) {
        return DropdownMenuItem<TodoCategory>(
          value: category,
          child: Row(
            children: [
              Icon(
                _categoryIcon(category),
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(_prettifyCategoryName(category.name)),
            ],
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }

  // Optional: Map category names to more polished labels
  String _prettifyCategoryName(String name) {
    return name
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  IconData _categoryIcon(TodoCategory category) {
    switch (category) {
      case TodoCategory.work:
        return Icons.work;
      case TodoCategory.personal:
        return Icons.person;
      case TodoCategory.shopping:
        return Icons.shopping_cart;
      case TodoCategory.health:
        return Icons.favorite;
      case TodoCategory.travel:
        return Icons.flight_takeoff;
      case TodoCategory.finance:
        return Icons.attach_money;
      case TodoCategory.education:
        return Icons.school;
      case TodoCategory.entertainment:
        return Icons.movie;
      case TodoCategory.home:
        return Icons.home;
      case TodoCategory.fitness:
        return Icons.fitness_center;
      case TodoCategory.hobbies:
        return Icons.palette;
      case TodoCategory.family:
        return Icons.family_restroom;
      case TodoCategory.friends:
        return Icons.group;
      case TodoCategory.selfCare:
        return Icons.spa;
      case TodoCategory.spirituality:
        return Icons.self_improvement;
      case TodoCategory.community:
        return Icons.people;
      case TodoCategory.volunteering:
        return Icons.volunteer_activism;
      case TodoCategory.pets:
        return Icons.pets;
      case TodoCategory.technology:
        return Icons.devices;
      case TodoCategory.fashion:
        return Icons.checkroom;
      case TodoCategory.food:
        return Icons.restaurant;
      case TodoCategory.sports:
        return Icons.sports_soccer;
      case TodoCategory.music:
        return Icons.music_note;
      case TodoCategory.art:
        return Icons.brush;
      case TodoCategory.books:
        return Icons.menu_book;
      case TodoCategory.movies:
        return Icons.local_movies;
      case TodoCategory.games:
        return Icons.videogame_asset;
      case TodoCategory.photography:
        return Icons.camera_alt;
      case TodoCategory.gardening:
        return Icons.grass;
      case TodoCategory.crafts:
        return Icons.construction;
      case TodoCategory.writing:
        return Icons.edit;
      case TodoCategory.cooking:
        return Icons.kitchen;
      case TodoCategory.homeImprovement:
        return Icons.build;
      case TodoCategory.other:
        return Icons.category;
    }
  }
}