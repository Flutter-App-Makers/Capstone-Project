import 'dart:math';
import 'package:flutter/material.dart';

class CatchableFish extends StatefulWidget {
  final Offset center;
  final double radius;
  final Duration swimDuration;
  final VoidCallback? onCaught;

  const CatchableFish({
    super.key,
    required this.center,
    this.radius = 60,
    this.swimDuration = const Duration(seconds: 4),
    this.onCaught,
  });

  @override
  State<CatchableFish> createState() => CatchableFishState();
}

class CatchableFishState extends State<CatchableFish>
    with TickerProviderStateMixin {
  late AnimationController _swimController;
  late AnimationController _catchController;
  late Animation<double> _angleAnim;

  bool caught = false;
  bool facingRight = true;

  @override
  void initState() {
    super.initState();

    _swimController = AnimationController(
      duration: widget.swimDuration,
      vsync: this,
    )..repeat(reverse: true);

    _angleAnim = Tween<double>(begin: 0, end: 2 * pi).animate(_swimController);

    _catchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _angleAnim.addListener(() {
      final dir = cos(_angleAnim.value);
      setState(() {
        facingRight = dir > 0;
      });
    });
  }

  void catchFish() {
    if (!mounted || caught) return;

    setState(() => caught = true);
    _swimController.stop();

    _catchController.forward().then((_) {
      widget.onCaught?.call();
    });
  }

  @override
  void dispose() {
    _swimController.dispose();
    _catchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return caught
        ? AnimatedBuilder(
            animation: _catchController,
            builder: (context, _) {
              final progress = _catchController.value;
              final fishStartY = widget.center.dy;

              double lineHeight;
              double hookY;
              double fishY;

              if (progress < 0.5) {
                // Phase 1: line grows down
                lineHeight = fishStartY * (progress / 0.5);
                hookY = lineHeight;
                fishY = fishStartY; // stays still
              } else {
                // Phase 2: line retracts and pulls fish
                final t = (progress - 0.5) / 0.5;
                final liftAmount = fishStartY * t;
                lineHeight = fishStartY - liftAmount;
                hookY = lineHeight;
                fishY = hookY + 16; // fish below hook
              }

              return Stack(
                children: [
                  // 🎣 Fishing line
                  Positioned(
                    left: widget.center.dx + 30,
                    top: 0,
                    child: Container(
                      width: 2,
                      height: lineHeight,
                      color: Colors.blueGrey,
                    ),
                  ),

                  // 🪝 Hook at bottom of line
                  Positioned(
                    left: widget.center.dx + 22,
                    top: hookY,
                    child: Image.asset('assets/hook.png', width: 16),
                  ),

                  // 🐟 Fish follows hook only during retract
                  Positioned(
                    left: widget.center.dx,
                    top: fishY,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(facingRight ? 0 : pi),
                      child: Image.asset('assets/fish.png', width: 60),
                    ),
                  ),
                ],
              );
            },
          )
        : AnimatedBuilder(
            animation: _angleAnim,
            builder: (context, _) {
              final dx = cos(_angleAnim.value) * widget.radius;
              final dy = sin(_angleAnim.value) * widget.radius * 0.5;
              return Positioned(
                left: widget.center.dx + dx,
                top: widget.center.dy + dy,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(facingRight ? 0 : pi),
                  child: Image.asset('assets/fish.png', width: 60),
                ),
              );
            },
          );
  }
}
