import 'package:flutter/material.dart';

class EmptyTodoPlaceholder extends StatelessWidget {
  const EmptyTodoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 200.0),
        child: Text(
          "Add a todo using the button below",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}