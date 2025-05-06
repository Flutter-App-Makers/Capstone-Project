import 'dart:math';
import 'package:flutter/material.dart';

class FishWidget extends StatefulWidget {
  final Offset center;
  final double radius;
  final Duration duration;

  const FishWidget({
    Key? key,
    required this.center,
    this.radius = 30.0,
    this.duration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<FishWidget> createState() => _FishWidgetState();
}

class _FishWidgetState extends State<FishWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late bool facingRight;

  @override
  void initState() {
    super.initState();
    facingRight = true;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _controller.addListener(() {
      final direction = cos(_animation.value);
      setState(() {
        facingRight = direction > 0;
      });
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
      builder: (_, __) {
        final dx = cos(_animation.value) * widget.radius;
        final dy =
            sin(_animation.value) * widget.radius * 0.5; // elliptical bobbing
        return Positioned(
          left: widget.center.dx + dx,
          top: widget.center.dy + dy,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(facingRight ? 0 : pi),
            child: Image.asset(
              'assets/fish.png',
              width: 80,
            ),
          ),
        );
      },
    );
  }
}
