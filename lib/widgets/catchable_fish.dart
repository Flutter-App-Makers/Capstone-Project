
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
    this.radius = 30,
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
  late Animation<double> _liftAnim;

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

    _liftAnim = Tween<double>(begin: 0, end: -500).animate(CurvedAnimation(
      parent: _catchController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      ),
      curve: Curves.easeInOut,
    ));

    _angleAnim.addListener(() {
      final dir = cos(_angleAnim.value);
      setState(() {
        facingRight = dir > 0;
      });
    });
  }

  void catchFish() {
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
              return Positioned(
                left: widget.center.dx,
                top: widget.center.dy + _liftAnim.value,
                child: Column(
                  children: [
                    Container(
                      width: 2,
                      height: -_liftAnim.value.clamp(0, 500).toDouble(),
                      color: Colors.white,
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(facingRight ? 0 : pi),
                      child: Image.asset('assets/fish.png', width: 60),
                    ),
                  ],
                ),
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
