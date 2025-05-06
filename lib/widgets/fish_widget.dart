import 'dart:math';
import 'package:flutter/material.dart';

class FishWidget extends StatefulWidget {
  final double verticalPosition;
  final Duration swimDuration;

  const FishWidget({
    Key? key,
    required this.verticalPosition,
    this.swimDuration = const Duration(seconds: 8),
  }) : super(key: key);

  @override
  State<FishWidget> createState() => _FishWidgetState();
}

class _FishWidgetState extends State<FishWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool facingRight = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.swimDuration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -0.3, end: 1.3).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          facingRight = !facingRight;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: widget.verticalPosition,
          left: MediaQuery.of(context).size.width * _animation.value,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(facingRight ? 0 : pi),
            child: Image.asset(
              'assets/fish.png', // Add a fish image to your assets folder
              width: 50,
            ),
          ),
        );
      },
    );
  }
}
